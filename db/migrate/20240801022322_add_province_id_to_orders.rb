class AddProvinceIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :province_id, :integer
  end
end
