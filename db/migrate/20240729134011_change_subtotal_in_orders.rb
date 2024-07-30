class ChangeSubtotalInOrders < ActiveRecord::Migration[6.1]
  def up
    # Ensure all existing rows have a non-null value for subtotal
    Order.where(subtotal: nil).update_all(subtotal: 0.0)
    
    # Change the column definition
    change_column :orders, :subtotal, :decimal, precision: 10, scale: 2, default: 0.0, null: false
  end

  def down
    # Optional: Revert changes if necessary
    change_column :orders, :subtotal, :decimal, precision: 10, scale: 2
  end
end
