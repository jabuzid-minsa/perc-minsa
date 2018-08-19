class CreateCostCenters < ActiveRecord::Migration
  def change
    create_table :cost_centers do |t|
      t.string :code, default: ''
      t.string :description, default: ''
      t.text :definition
      t.integer :function, default: 0
      t.references :cost_center, index: true, foreign_key: true
      t.references :geography, index: true, foreign_key: true
      t.references :language, index: true, foreign_key: true
      t.references :staff, index: true, foreign_key: true
      t.references :supply, index: true, foreign_key: true
      t.references :cost_distribution, index: true, foreign_key: true
      t.references :primary_production_unit
      t.references :secondary_production_unit
      t.references :tertiary_production_unit
      t.references :quaternary_production_unit
      t.references :quinary_production_unit
      t.boolean :state, default: true

      t.timestamps null: false
    end
    add_index :cost_centers, [:code, :geography_id], :unique => true
  end
end
