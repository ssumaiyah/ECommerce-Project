
# app/admin/orders.rb
ActiveAdmin.register Order do
  # Permitted parameters
  permit_params :user_id, :total_amount, :order_date, :status
  filter :province_id
  filter :order_tax_rate_id
  # Index page configuration
  index do
    selectable_column
    id_column
    column :user
    column :order_date
    column :subtotal
    column :total_amount
    actions
  end

  # Show page configuration
  show do
    attributes_table do
      row :user
      row :order_date
      row :subtotal
      row :total_amount
      row :status
    end

    panel "Order Items" do
      table_for order.order_items do
        column :product do |order_item|
          link_to order_item.product.name, admin_product_path(order_item.product)
        end
        column :quantity
        column :price_at_purchase
        column "Total Price" do |order_item|
          number_to_currency(order_item.total_price)
        end
      end
    end

    panel "Taxes" do
      taxes = order.calculate_taxes
      attributes_table_for taxes do
        row :pst do
          number_to_currency(taxes[:pst])
        end
        row :gst do
          number_to_currency(taxes[:gst])
        end
        row :hst do
          number_to_currency(taxes[:hst])
        end
        row :qst do
          number_to_currency(taxes[:qst])
        end
      end
    end
  end

  # Custom action to list all customers with their orders
  collection_action :list_customers_with_orders, method: :get do
    @customers = User.includes(:orders).where.not(orders: { id: nil })
    render template: 'admin/orders/list_customers_with_orders'
  end

  # Menu item for the custom action
  sidebar "Custom Reports", only: :index do
    ul do
      li link_to "Customers with Orders", list_customers_with_orders_admin_orders_path
    end
  end
end

