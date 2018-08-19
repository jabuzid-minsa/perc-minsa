class CreateDistributionAreas < ActiveRecord::Migration
  def change
    create_table :distribution_areas do |t|
      t.integer :year, limit: 2
      t.integer :month, limit: 1
      t.decimal :meters, precision: 42, scale: 10, default: 0
      t.references :entity, index: true, foreign_key: true
      t.references :cost_center, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :distribution_areas, [:year, :month, :entity_id, :cost_center_id], :unique => true, :name => 'uk_distribution_areas'
  end
end
