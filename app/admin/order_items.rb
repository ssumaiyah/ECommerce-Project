ActiveAdmin.register OrderItem do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  
  filter :order_id
  filter :product
  filter :quantity
  filter :price_at_purchase
  filter :created_at
   permit_params :order_id, :product_id, :quantity, :price_at_purchase
  #
  # or
  #
  # permit_params do
  #   permitted = [:order_id, :product_id, :quantity, :price_at_purchase]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
