class AddSpreadsheetIdToDailyReports < ActiveRecord::Migration[5.1]
  def change
    add_reference :daily_reports, :spreadsheet, foreign_key: true
  end
end
