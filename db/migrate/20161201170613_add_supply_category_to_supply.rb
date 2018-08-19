class AddSupplyCategoryToSupply < ActiveRecord::Migration
  def change
    add_reference :supplies, :supplies_category, index: true, foreign_key: true
  end
end
