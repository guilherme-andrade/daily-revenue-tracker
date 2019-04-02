require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

class GoogleSheetsWriter
  def initialize
    @oob_uri = 'urn:ietf:wg:oauth:2.0:oob'.freeze
    @app_name = 'Koti'.freeze
    @credentials_path = 'credentials.json'.freeze
    @token_path = 'token.yaml'.freeze
    @scope = Google::Apis::SheetsV4::AUTH_SPREADSHEETS
    @service = Google::Apis::SheetsV4::SheetsService.new
    @service.client_options.application_name = @app_name
    @service.authorization = authorize
  end

  def report_column
    if @report.business == 'store'
      new_column = @report.to_store_column
    else
      new_column = @report.to_column
    end
    Google::Apis::SheetsV4::ValueRange
      .new(values: new_column, major_dimension: 'COLUMNS')
  end

  def assign_spreadsheet
    @spreadsheet = Spreadsheet.find_or_create_by(
      year: Time.now.year,
      business: @report.business
    )

    unless @spreadsheet.remote_id
      request_body = Google::Apis::SheetsV4::Spreadsheet.new(
        properties: {
          title: "#{@report.business.capitalize} Daily Revenues - #{Time.now.year}"
        }
      )
      @remote_spreadsheet = @service.create_spreadsheet(request_body)

      batch_request = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new
      batch_request.requests = monthly_sheets_hashes

      @service.batch_update_spreadsheet(@remote_spreadsheet.spreadsheet_id, batch_request)

      @spreadsheet.update(remote_id: @remote_spreadsheet.spreadsheet_id)
    end

    @report.spreadsheet = @spreadsheet
    @report.save!
    @spreadsheet_id = @report.spreadsheet.remote_id
  end

  def write(report)
    @report = report
    assign_spreadsheet
    sheet_name = @report.date.strftime("%B %y")
    range = "#{sheet_name}!A:ZZ"

    spreadsheet_values = @service.get_spreadsheet_values(@spreadsheet_id, range).values

    unless spreadsheet_values
      @service.append_spreadsheet_value(
        @spreadsheet_id,
        "#{sheet_name}!#{s26(1)}:#{s26(1)}",
        headers_column,
        value_input_option: 'RAW'
      )
      spreadsheet_values = @service.get_spreadsheet_values(@spreadsheet_id, range).values
    end

    column_number = spreadsheet_values.first.length + 1

    column = report_column

    range = "#{sheet_name}!#{s26(column_number)}:#{s26(column_number)}"

    @service.append_spreadsheet_value(
      @spreadsheet_id,
      range,
      column,
      value_input_option: 'RAW'
    )
  end

  private

  def authorize
    client_id = Google::Auth::ClientId.from_file(@credentials_path)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: @token_path)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, @scope, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: @oob_uri)
      puts 'Open the following URL in the browser and enter the ' \
           "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: @oob_uri
      )
    end
    credentials
  end

  def s26(number)
    alpha26 = ('a'..'z').to_a
    return '' if number < 1
    s = ''
    q = number
    loop do
      q, r = (q - 1).divmod(26)
      s.prepend(alpha26[r])
      break if q.zero?
    end
    s
  end

  def month_dates
    (Date.new(Time.now.year, 1)..Date.new(Time.now.year, 12))
      .select { |d| d.day == 1 }
      .map { |d| d.strftime('%B %y') }
  end

  def monthly_sheets_hashes
    month_dates.map do |month_year|
      {
        add_sheet: {
          properties: {
            title: month_year
          }
        }
      }
    end
  end

  def headers_column
    headers = [
      %w[
        Name
        Date
        Lunch_Anzahl_Personen
        Lunch_Umsatz
        Dinner_Personen
        Dinner_Umsatz
        Bar
        MasterCard
        Visa
        Maestro
        Andere
        Kreditkarte_Total
        Treuekarte
        Rechnung
        Rabatte
        LunchChecks
        Einkauf
        Gutschein_No.
        Summe_Gutschein
        Umsatz
      ].map { |header| header.humanize }
    ]
    Google::Apis::SheetsV4::ValueRange
      .new(values: headers, major_dimension: 'COLUMNS')
  end
end

