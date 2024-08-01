class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_provinces, only: [:checkout]

  def show
    @order_items = current_cart.order_items
  end

  def add_item
    product = Product.find(params[:product_id])
    current_cart.add_product(product.id, params[:quantity].to_i)
    redirect_to cart_path, notice: 'Product added to cart.'
  end

  def update_item
    order_item = current_cart.order_items.find(params[:id])
    order_item.update(quantity: params[:quantity].to_i)
    redirect_to cart_path, notice: 'Cart updated.'
  end

  def remove_item
    order_item = current_cart.order_items.find(params[:id])
    order_item.destroy
    redirect_to cart_path, notice: 'Item removed from cart.'
  end

 
  def checkout
    if current_user.address.blank? || current_user.province.blank?
      redirect_to edit_user_registration_path, alert: 'Please update your address and province before checking out.'
      return
    end

    @order = current_cart
    @order_items = @order.order_items
    @subtotal = @order_items.sum(&:total_price)
    @taxes = calculate_taxes(@subtotal)
    @total_amount = @subtotal + @taxes.values.sum
  end


 
  def place_order
    @order = current_cart
  
    if @order.update(order_params)
      @order.calculate_totals # Ensure totals are recalculated
      @order.update(status: 'completed')
      session[:order_id] = nil
      redirect_to order_path(@order), notice: 'Order successfully placed!'
    else
      render :checkout
    end
  end
  
  

  private 

def calculate_taxes(subtotal)
  province = current_user.province
  return { pst: 0, gst: 0, hst: 0, qst: 0 } unless province
  
  tax_rates = province.tax_rates_provinces.map(&:tax_rate)
  pst = tax_rates.select { |tr| tr.tax_type == 'PST' }.first&.rate.to_f / 100 * subtotal
  gst = tax_rates.select { |tr| tr.tax_type == 'GST' }.first&.rate.to_f / 100 * subtotal
  hst = tax_rates.select { |tr| tr.tax_type == 'HST' }.first&.rate.to_f / 100 * subtotal
  qst = tax_rates.select { |tr| tr.tax_type == 'QST' }.first&.rate.to_f / 100 * subtotal
  { pst: pst, gst: gst, hst: hst, qst: qst }
end

  private

  def current_cart
    @current_cart ||= find_or_create_cart
  end

  def find_or_create_cart
    if session[:order_id]
      order = current_user.orders.find_by(id: session[:order_id], status: 'in_progress')
      return order if order
    end
    create_new_cart
  end

  def create_new_cart
    order = current_user.orders.create(status: 'in_progress')
    session[:order_id] = order.id
    order
  end

  def order_params
  params.require(:order).permit(:subtotal, :total_amount, :order_date, :province_id, :address, :status)
end

  def set_provinces
    @provinces = Province.all
  end
end
