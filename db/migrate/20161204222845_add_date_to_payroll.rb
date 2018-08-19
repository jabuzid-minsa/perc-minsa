class AddDateToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :year, :integer, limit: 2
    add_column :payrolls, :month, :integer, limit: 1
  end
end
