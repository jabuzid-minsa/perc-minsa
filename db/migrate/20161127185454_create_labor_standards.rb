class CreateLaborStandards < ActiveRecord::Migration
  def change
    create_table :labor_standards do |t|
      t.string :code, default: ''
      t.string :description, default: ''
      t.references :geography, index: true, foreign_key: true
      t.boolean :state, default: true

      t.timestamps null: false
    end
  end
end
