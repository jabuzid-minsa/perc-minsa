class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.string :code, default: ''
      t.string :abbreviation, default: ''
      t.string :description, default: ''
      t.integer :payroll_type, default: 0
      t.references :care_level, index: true, foreign_key: true
      t.references :geography, index: true, foreign_key: true
      t.boolean :state, default: true

      t.timestamps null: false
    end
    add_index :entities, [:code, :geography_id], :unique => true
  end
end
