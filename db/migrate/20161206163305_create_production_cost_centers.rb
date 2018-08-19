class CreateProductionCostCenters < ActiveRecord::Migration
  def change
    create_table :production_cost_centers do |t|
      t.integer :year, limit: 2
      t.integer :month, limit: 1
      t.decimal :value, precision: 42, scale: 10, default: 0
      t.integer :production_units, limit: 1
      t.references :cost_center, index: true, foreign_key: true
      t.references :entity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
