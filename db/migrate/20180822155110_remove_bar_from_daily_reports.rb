class RemoveBarFromDailyReports < ActiveRecord::Migration[5.1]
  def change
    remove_column :daily_reports, :bar, :boolean
  end
end
