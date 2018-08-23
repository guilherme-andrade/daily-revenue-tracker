class CreateDailyReports < ActiveRecord::Migration[5.1]
  def change
    create_table :daily_reports do |t|
      t.string :name_und_vorname
      t.date :date
      t.float :umsatz
      t.integer :anzahl_personen
      t.float :summe_lunchchecks
      t.float :kreditkarte_total
      t.float :mastercard
      t.float :visa
      t.float :maestro
      t.float :andere
      t.float :summe_treuekarte
      t.float :summe_rabatte
      t.float :summe_rechnung
      t.float :summe_gutschein
      t.integer :gutschein_nummer
      t.float :summe_einkauf

      t.timestamps
    end
  end
end
