
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

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  private

  def product_params
    params.require(:product).permit(:artisan_id, :name, :description, :price, :quantity_available)
  end


end

