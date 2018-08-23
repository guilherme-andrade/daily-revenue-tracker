class AddStatusToDailyReports < ActiveRecord::Migration[5.1]
  def change
    add_column :daily_reports, :status, :boolean
  end
end
