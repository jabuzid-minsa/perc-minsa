class CreateNetworks < ActiveRecord::Migration
  def change
    create_table :networks do |t|
      t.string :code, default: ''
      t.string :description, default: ''
      t.references :geography, index: true, foreign_key: true
      t.boolean :state, default: true

      t.timestamps null: false
    end
    add_index :networks, [:code, :geography_id], :unique => true
  end
end
