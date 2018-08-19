class CreateProgrammingHours < ActiveRecord::Migration
  def change
    create_table :programming_hours do |t|
      t.integer :year, limit: 2
      t.integer :month, limit: 1
      t.integer :total, default: 0
      t.decimal :paid, precision: 42, scale: 10, default: 0
      t.decimal :hours, precision: 42, scale: 10, default: 0
      t.references :entity, index: true, foreign_key: true
      t.references :cost_center, index: true, foreign_key: true
      t.references :payroll, index: true, foreign_key: true
      t.references :salary_component, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :programming_hours, [:year, :month, :entity_id, :cost_center_id, :payroll_id, :salary_component_id], :unique => true,
              :name => 'uk_programming_hours'
  end
end
