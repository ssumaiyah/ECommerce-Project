class CreateTaxRates < ActiveRecord::Migration[7.1]
  def change
    create_table :tax_rates do |t|
      t.string :name
      t.decimal :rate
      t.string :tax_type

      t.timestamps
    end
  end
end
