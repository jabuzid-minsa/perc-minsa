class CreateSuppliesCategories < ActiveRecord::Migration
  def change
    create_table :supplies_categories do |t|
      t.string :code, default: ''
      t.string :description, default: ''
      t.text :definition
      t.references :geography, index: true, foreign_key: true
      t.references :language, index: true, foreign_key: true
      t.boolean :state, default: true

      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
    add_index :supplies_categories, [:code, :geography_id], :unique => true
  end
end
