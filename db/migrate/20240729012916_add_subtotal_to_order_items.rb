class AddSubtotalToOrderItems < ActiveRecord::Migration[7.1]
  def change
    add_column :order_items, :subtotal, :decimal
  end
end
