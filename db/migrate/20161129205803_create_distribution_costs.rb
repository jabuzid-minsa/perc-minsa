class CreateDistributionCosts < ActiveRecord::Migration
  def change
    create_table :distribution_costs do |t|
      t.integer :year, limit: 2
      t.integer :month, limit: 1
      t.decimal :value, precision: 42, scale: 10, default: 0
      t.references :cost_center, index: true, foreign_key: true
      t.references :supported_cost_center
      t.references :entity, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :distribution_costs, [:year, :month, :entity_id, :supported_cost_center_id, :cost_center_id], :unique => true,
              :name => 'uk_distribution_costs'
  end
end
