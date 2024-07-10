class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :quantity_available
      t.references :artisan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
