# app/controllers/checkout_controller.rb
class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def new
    @order = current_cart
  end

  def create
    @order = current_cart
    @order.status = 'completed'
    if @order.save
      OrderMailer.order_confirmation(@order).deliver_now
      redirect_to order_path(@order)
    else
      render :new
    end
  end

  private

  def current_cart
    current_user.orders.find_or_create_by(status: 'cart')
  end
end
