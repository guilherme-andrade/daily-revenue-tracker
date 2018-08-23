class AddBarToDailyReports < ActiveRecord::Migration[5.1]
  def change
    add_column :daily_reports, :bar, :float
  end
end
