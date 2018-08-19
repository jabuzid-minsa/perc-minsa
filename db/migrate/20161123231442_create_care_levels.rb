class CreateCareLevels < ActiveRecord::Migration
  def change
    create_table :care_levels do |t|
      t.string :code, default: ''
      t.string :description, default: ''
      t.text :definition
      t.references :geography, index: true, foreign_key: true
      t.references :language, index: true, foreign_key: true
      t.boolean :state, default: true

      t.timestamps null: false
    end
    add_index :care_levels, [:code, :geography_id], :unique => true
  end
end
