# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.includes(:order_items, :order_tax_rates)
  end

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
    @order = current_user.orders.find(params[:id])
    @order_items = @order.order_items.includes(:product)
    @subtotal = @order.subtotal
    @total_amount = @order.total_amount
    Rails.logger.debug { "Order Total Amount: #{@total_amount}" }
  end

  def add_to_cart
    @order = current_user.orders.in_progress.first_or_create
    @order.add_product(params[:product_id], 1) # Adjust quantity as needed
    redirect_to products_path, notice: "Product added to cart."
  end

  # Action to update quantity of an order item in the cart
  def update_item
    order_item = current_order.order_items.find(params[:id])
    quantity = params[:quantity].to_i
    if quantity.positive?
      order_item.update(quantity:)
    else
      order_item.destroy
    end
    redirect_to cart_path, notice: "Item quantity updated."
  end

  # Action to remove an item from the cart
  def remove_item
    order_item = current_order.order_items.find(params[:id])
    order_item.destroy
    redirect_to cart_path, notice: "Item removed from cart."
  end

  private

  def current_order
    @current_order ||= current_user.orders.in_progress.last || current_user.orders.create(
      status: "in_progress", order_date: Time.zone.today
    )
  end

  def order_params
    params.require(:order).permit(:subtotal, :total_amount, :order_date, :status)
  end
end
