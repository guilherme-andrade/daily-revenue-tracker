class AddLunchAndDinnerAttributesToDailyReports < ActiveRecord::Migration[5.1]
  def change
    add_column :daily_reports, :dinner_umsatz, :float
    add_column :daily_reports, :dinner_anzahl_personen, :integer
    add_column :daily_reports, :lunch_umsatz, :float
    add_column :daily_reports, :lunch_anzahl_personen, :integer
  end
end
