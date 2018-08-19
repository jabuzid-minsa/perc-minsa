class CreateIncomes < ActiveRecord::Migration
  def change
    create_table :incomes do |t|
      t.integer :year, limit: 2
      t.integer :month, limit: 1
      t.decimal :value, precision: 42, scale: 10, default: 0
      t.references :entity, index: true, foreign_key: true
      t.references :cost_center, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :incomes, [:year, :month, :entity_id, :cost_center_id], :unique => true,
              :name => 'uk_incomes'
  end
end
