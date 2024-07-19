class CartsController < ApplicationController
  before_action :authenticate_user!

  def remove_item
    order_item = current_cart.order_items.find(params[:id])
    order_item.destroy
    redirect_to cart_path, notice: 'Item removed from cart.'
  end

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
end
