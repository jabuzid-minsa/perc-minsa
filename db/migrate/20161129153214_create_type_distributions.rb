class CreateTypeDistributions < ActiveRecord::Migration
  def change
    create_table :type_distributions do |t|
      t.string :code, default: ''
      t.string :description, default: ''
      t.references :geography, index: true, foreign_key: true
      t.references :language, index: true, foreign_key: true
      t.boolean :state, default: true

      t.timestamps null: false
    end
    add_index :type_distributions, [:code, :geography_id], :unique => true
    add_index :type_distributions, [:code, :language_id], :unique => true
  end
end
