class AddBusinessToDailyReports < ActiveRecord::Migration[5.1]
  def change
    add_column :daily_reports, :business, :string
  end
end
