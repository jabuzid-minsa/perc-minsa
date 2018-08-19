class CreateLaborLaws < ActiveRecord::Migration
  def change
    create_table :labor_laws do |t|
      t.integer :year, limit: 2
      t.integer :month, limit: 1
      t.decimal :min_wage, precision: 42, scale: 10, default: 0
      t.references :staff, index: true, foreign_key: true
      t.references :labor_standard, index: true, foreign_key: true
      t.references :contract_type, index: true, foreign_key: true
      t.references :entity, index: true, foreign_key: true
      t.boolean :state, default: true

      t.timestamps null: false
    end
    add_index :labor_laws, [:year, :month, :staff_id, :labor_standard_id, :contract_type_id, :entity_id], :unique => true,
              :name => 'uk_labor_laws'
  end
end
