class AddUserToGeographies < ActiveRecord::Migration
  def change
    add_reference :geographies, :user, foreign_key: true
  end
end
