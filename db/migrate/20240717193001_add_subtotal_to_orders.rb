class AddSubtotalToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :subtotal, :decimal, precision: 10, scale: 2, default: 0.0, null: false
  end
end
