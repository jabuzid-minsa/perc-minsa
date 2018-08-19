class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :abbreviation, default: ''
      t.string :name, default: ''
      t.boolean :state, default: true

      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end

    add_index :languages, [:abbreviation], :unique => true
  end
end
