class RemoveMealsFromDailyReports < ActiveRecord::Migration[5.1]
  def change
    remove_column :daily_reports, :meal, :string
  end
end
