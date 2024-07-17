class CreateTaxRatesProvinces < ActiveRecord::Migration[7.1]
  def change
    create_table :tax_rates_provinces do |t|
      t.references :tax_rate, null: false, foreign_key: true
      t.references :province, null: false, foreign_key: true

      t.timestamps
    end
  end
end
