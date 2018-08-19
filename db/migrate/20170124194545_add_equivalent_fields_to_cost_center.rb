class AddEquivalentFieldsToCostCenter < ActiveRecord::Migration
  def change
    add_column :cost_centers, :comprehensive, :boolean, default: false
    add_column :cost_centers, :secondary_equivalent_to_primary, :decimal, precision: 42, scale: 10, default: 0
    add_column :cost_centers, :tertiary_equivalent_to_primary, :decimal, precision: 42, scale: 10, default: 0
    add_column :cost_centers, :quaternary_equivalent_to_primary, :decimal, precision: 42, scale: 10, default: 0
    add_column :cost_centers, :quinary_equivalent_to_primary, :decimal, precision: 42, scale: 10, default: 0
  end
end
