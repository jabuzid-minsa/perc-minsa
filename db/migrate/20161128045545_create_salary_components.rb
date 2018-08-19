class CreateSalaryComponents < ActiveRecord::Migration
  def change
    create_table :salary_components do |t|
      t.string :code, default: ''
      t.string :abbreviation, default: ''
      t.string :description, default: ''
      t.decimal :max_value, precision: 42, scale: 10, default: 0
      t.decimal :rate, precision: 42, scale: 10, default: 0
      t.references :geography, index: true, foreign_key: true
      t.boolean :state, default: true

      t.timestamps null: false
    end
    add_index :salary_components, [:code, :geography_id], :unique => true
  end
end
