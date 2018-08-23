class RemoveUmsatzAndAnzahlPersonenFromDailyReports < ActiveRecord::Migration[5.1]
  def change
    remove_column :daily_reports, :umsatz, :float
    remove_column :daily_reports, :anzahl_personen, :integer
  end
end
