class AddUserToDailyReports < ActiveRecord::Migration[5.1]
  def change
    add_reference :daily_reports, :user, foreign_key: true
  end
end
