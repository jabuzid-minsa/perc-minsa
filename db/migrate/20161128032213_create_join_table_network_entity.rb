class CreateJoinTableNetworkEntity < ActiveRecord::Migration
  def change
    create_join_table :networks, :entities do |t|
      # t.index [:network_id, :entity_id]
      # t.index [:entity_id, :network_id]
    end
  end
end
