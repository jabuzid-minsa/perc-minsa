class CreateProductionUnits < ActiveRecord::Migration
  def change
    create_table :production_units do |t|
      t.string :code, default: ''
      t.string :abbreviation, default: ''
      t.string :description, default: ''
      t.text :definition
      t.references :geography, index: true, foreign_key: true
      t.references :language, index: true, foreign_key: true
      t.boolean :state, default: true

      t.timestamps null: false
    end
    add_index :production_units, [:code, :geography_id], :unique => true
    add_index :production_units, [:abbreviation, :geography_id], :unique => true
  end
end
