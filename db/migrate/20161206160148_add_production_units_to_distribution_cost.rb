class AddProductionUnitsToDistributionCost < ActiveRecord::Migration
  def change
    add_column :distribution_costs, :production_units, :integer
  end
end
