class AddAttributesToDailyReports < ActiveRecord::Migration[5.1]
  def change
    add_column :daily_reports, :total_umsatz, :float
  end
end
