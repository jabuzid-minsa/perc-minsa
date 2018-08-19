class CreateGeographies < ActiveRecord::Migration
  def change
    create_table :geographies do |t|
      t.integer :numerical_code, default: 0
      t.string :first_level, default: '', limit: 3
      t.integer :second_level, default: 0, limit: 2
      t.integer :third_level, default: 0, limit: 2
      t.integer :fourth_level, default: 0, limit: 2
      t.integer :fifth_level, default: 0, limit: 2
      t.string :description, default: ''
      t.integer :depth_detail, deafult: 4, limit: 1
      t.boolean :state, default: true

      t.timestamps null: false
    end

    add_index :geographies, [:numerical_code, :second_level, :third_level, :fourth_level, :fifth_level], :unique => true,
        :name => 'uk_geography_levels'
  end
end