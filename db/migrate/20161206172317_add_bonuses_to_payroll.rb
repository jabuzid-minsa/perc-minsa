class AddBonusesToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :bonuses, :decimal, precision: 42, scale: 10, default: 0
    add_column :payrolls, :benefits, :decimal, precision: 42, scale: 10, default: 0
  end
end
