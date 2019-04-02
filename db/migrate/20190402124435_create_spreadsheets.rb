class CreateSpreadsheets < ActiveRecord::Migration[5.1]
  def change
    create_table :spreadsheets do |t|
      t.string :remote_id
      t.integer :year
      t.string :business

      t.timestamps
    end
  end
end
