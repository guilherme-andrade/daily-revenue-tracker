class AddMealToDailyReports < ActiveRecord::Migration[5.1]
  def change
    add_column :daily_reports, :meal, :string
  end
end
