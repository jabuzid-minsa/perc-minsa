class CreatePayrolls < ActiveRecord::Migration
  def change
    create_table :payrolls do |t|
      t.string :dni, default: ''
      t.string :name, default: ''
      t.decimal :salary, precision: 42, scale: 10, default: 0
      t.references :labor_law, index: true, foreign_key: true
      t.references :entity, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :payrolls, [:dni, :entity_id], :unique => true
  end
end
