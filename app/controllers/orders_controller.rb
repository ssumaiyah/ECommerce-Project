# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @order = Order.new
  end

  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      session[:cart] = nil # Clear cart after order is placed
      redirect_to order_path(@order), notice: "Order successfully placed!"
    else
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
    @order_items = @order.order_items.includes(:product)
  end

  def add_to_cart
    @order = current_user.orders.in_progress.first_or_create
    @order.add_product(params[:product_id], 1) # Adjust quantity as needed
    redirect_to products_path, notice: "Product added to cart."
  end

  private

  def order_params
    params.require(:order).permit(:subtotal, :total_amount, :order_date, :status, :province_id)
  end
end
