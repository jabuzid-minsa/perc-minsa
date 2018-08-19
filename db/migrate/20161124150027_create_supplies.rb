class CreateSupplies < ActiveRecord::Migration
  def change
    create_table :supplies do |t|
      t.string :code, default: ''
      t.string :description, default: ''
      t.text :definition
      t.references :supply, index: true, foreign_key: true
      t.references :geography, index: true, foreign_key: true
      t.references :language, index: true, foreign_key: true
      t.boolean :state, default: true

      t.timestamps null: false
    end
    add_index :supplies, [:code, :geography_id], :unique => true
  end
end
