class CreateOrderTaxRates < ActiveRecord::Migration[7.1]
  def change
    create_table :order_tax_rates do |t|
      t.references :order, null: false, foreign_key: true
      t.references :tax_rate, null: false, foreign_key: true

      t.timestamps
    end
  end
end
