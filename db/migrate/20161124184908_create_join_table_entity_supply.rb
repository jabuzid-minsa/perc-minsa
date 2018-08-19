class CreateJoinTableEntitySupply < ActiveRecord::Migration
  def change
    create_join_table :entities, :supplies do |t|
      # t.index [:entity_id, :supply_id]
      # t.index [:supply_id, :entity_id]
    end
  end
end
