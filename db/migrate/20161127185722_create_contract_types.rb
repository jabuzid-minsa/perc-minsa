class CreateContractTypes < ActiveRecord::Migration
  def change
    create_table :contract_types do |t|
      t.string :code, default: ''
      t.string :description, default: ''
      t.references :geography, index: true, foreign_key: true
      t.boolean :state, default: true

      t.timestamps null: false
    end
  end
end
