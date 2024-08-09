# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.includes(:order_items, :order_tax_rates)
    @orders_with_taxes = []

    @orders.each do |order|
      next if order.province_id.blank?

      order_items = order.order_items
      order_subtotal = order_items.sum(&:total_price)
      order_taxes = calculate_taxes_for_order(order_subtotal, order.province_id) # Use the new method
      order_total_amount = order_subtotal + order_taxes.values.sum
      order.update(subtotal: order_subtotal, total_amount: order_total_amount)

      @orders_with_taxes << {
        order:,
        taxes: order_taxes
      }
    end
  end

  def show
    @order = current_user.orders.find(params[:id])
    @order_items = @order.order_items.includes(:product) # Load order items and associated products
    @subtotal = @order.subtotal
    @taxes = @order.calculate_taxes # This uses the Order model's method
    @total_amount = @order.total_amount
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: "Order not found."
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

  def new
    @order = Order.new
  end

  def add_to_cart
    @order = current_user.orders.in_progress.first_or_create
    @order.add_product(params[:product_id], 1) # Adjust quantity as needed
    redirect_to products_path, notice: "Product added to cart."
  end

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

  def remove_item
    order_item = current_order.order_items.find(params[:id])
    order_item.destroy
    redirect_to cart_path, notice: "Item removed from cart."
  end

  private

  def calculate_taxes_for_order(subtotal, province_id)
    province = Province.find(province_id)
    return { pst: 0, gst: 0, hst: 0, qst: 0 } unless province

    tax_rates = province.tax_rates_provinces.map(&:tax_rate)
    pst = tax_rates.find { |tr| tr.tax_type == "PST" }&.rate.to_f / 100 * subtotal
    gst = tax_rates.find { |tr| tr.tax_type == "GST" }&.rate.to_f / 100 * subtotal
    hst = tax_rates.find { |tr| tr.tax_type == "HST" }&.rate.to_f / 100 * subtotal
    qst = tax_rates.find { |tr| tr.tax_type == "QST" }&.rate.to_f / 100 * subtotal
    { pst:, gst:, hst:, qst: }
  end

  def current_order
    @current_order ||= current_user.orders.in_progress.last || current_user.orders.create(
      status: "in_progress", order_date: Time.zone.today
    )
  end

  def order_params
    params.require(:order).permit(:subtotal, :total_amount, :order_date, :status)
  end

  def list_customers_with_orders
    @customers = Customer.joins(:orders).distinct.order("orders.created_at DESC")
    @orders_with_taxes = []

    @customers.each do |customer|
      customer.orders.each do |order|
        taxes = order.calculate_taxes
        @orders_with_taxes << {
          customer:,
          order:,
          taxes:
        }
      end
    end
  end
end
