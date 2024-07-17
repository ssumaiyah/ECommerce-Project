# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
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
  end

  private

  def order_params
    params.require(:order).permit(:subtotal, :total_amount, :order_date, :status, :province_id)
  end
end
