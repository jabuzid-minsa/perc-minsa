class AddTotalRevenueToIncomes < ActiveRecord::Migration
  def change
    add_column :incomes, :total_revenue, :decimal, precision: 28, scale: 6, default: 0
  end
end
