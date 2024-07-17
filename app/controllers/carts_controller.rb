# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  def show
    @cart_items = session[:cart] || []
  end

  def add_to_cart
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i
    product = Product.find(product_id)

    session[:cart] ||= []
    session[:cart] << { product_id: product_id, quantity: quantity }

    redirect_to cart_path, notice: "#{product.name} was successfully added to your cart."
  end

  def remove_from_cart
    product_id = params[:product_id].to_i

    session[:cart]&.reject! { |item| item[:product_id] == product_id }

    redirect_to cart_path, notice: "Product was successfully removed from your cart."
  end
  def show
    @cart_items = session[:cart] || []  # Assuming your cart items are stored in session

    # Fetch products for each cart item
    @products_in_cart = @cart_items.map do |item|
      product = Product.find_by(id: item[:product_id])
      if product.present?
        { quantity: item[:quantity], product: product }
      else
        # Handle case where product is not found (optional)
        { quantity: item[:quantity], product: nil }
      end
    end
  end
end
