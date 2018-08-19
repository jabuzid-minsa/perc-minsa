class CreateJoinTableEntityStaff < ActiveRecord::Migration
  def change
    create_join_table :entities, :staffs do |t|
      # t.index [:entity_id, :staff_id]
      # t.index [:staff_id, :entity_id]
    end
  end
end
