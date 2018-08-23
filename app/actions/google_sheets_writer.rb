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

  def report_column(report)
    new_column = report.to_column
    Google::Apis::SheetsV4::ValueRange.new(values: new_column, major_dimension: 'COLUMNS')
  end

  def write(report)
    if report.business == 'restaurant'
      spreadsheet_id = '1d2-SGlGjPAR_f9E60yy6yuijJv0BaegFmg8ZjJrjx00'
    elsif report.business == 'coffee'
      spreadsheet_id = '1koMvadlWcWrscIP0kNWNnbyv3EGGh1bH2ogUrMLb8ro'
    end
    sheet_name = report.date.strftime("%B")
    range = "#{sheet_name}!A:ZZ"
    column_number = @service.get_spreadsheet_values(spreadsheet_id, range).values.first.length + 1
    column = report_column(report)
    range = "#{sheet_name}!#{s26(column_number)}:#{s26(column_number)}"
    response = @service.append_spreadsheet_value(spreadsheet_id, range, column, value_input_option: "RAW")
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
end

