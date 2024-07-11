
class ProductsController < ApplicationController
  def index
    @products = Product.all

    if params[:on_sale]
      @products = @products.on_sale
    end

    if params[:new_products]
      @products = @products.newly_added(3.days.ago)
    end

    if params[:recently_updated]
      @products = @products.recently_updated(3.days.ago)
    end

    @products = Product.page(params[:page]).per(10)
  end 

  def show
    @product = Product.find(params[:id])
  end
end
