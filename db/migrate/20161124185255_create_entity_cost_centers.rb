class CreateEntityCostCenters < ActiveRecord::Migration
  def change
    create_table :entity_cost_centers, id: false do |t|
      t.references :entity, index: true, foreign_key: true
      t.references :cost_center, index: true, foreign_key: true
      t.integer :function, default: 0

      t.timestamps null: false
    end
  end
end
