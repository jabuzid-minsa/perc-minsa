class CreateIncomeDefinitions < ActiveRecord::Migration
  def change
    create_table :income_definitions do |t|
      t.boolean :invoice, default: true
      t.references :cost_center, index: true, foreign_key: true
      t.references :entity, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :income_definitions, [:cost_center_id, :entity_id], :unique => true
  end
end
