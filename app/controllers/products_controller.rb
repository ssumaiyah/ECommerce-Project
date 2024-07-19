class ProductsController < ApplicationController
  before_action :set_product, only: [:show,:update, :edit, :add_item_cart], except: [:index, :search]
  before_action :authenticate_user!, only: [:add_item_cart]

  def index
    @products = Product.page(params[:page]).per(10)
    @new_products = Product.new_products
    @recently_updated_products = Product.recently_updated
  end

  def search
    @search_query = params[:search]
    @category_id = params[:category_id]

    # Base query with eager loading of categories
    @products = Product.includes(:categories)

    # Apply category filter if present
    if @category_id.present? && @category_id != "0"
      @products = @products.joins(:product_categories).where(product_categories: { category_id: @category_id })
    end

    # Apply search query if present
    if @search_query.present?
      @products = @products.where("products.name LIKE ? OR products.description LIKE ?", "%#{@search_query}%", "%#{@search_query}%")
    end

    # Paginate the results
    @products = @products.distinct.page(params[:page]).per(10)

    # Render the search results view
    render 'search_results'
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, notice: 'No products found.'

  end

  def add_item_cart
    @product = Product.find(params[:id])
    current_order.add_product(@product.id, params[:quantity].to_i)
    redirect_to product_path(@product), notice: 'Product added to cart.'
  end

  def edit
    # No need to define @product here, it's already set by the before_action callback
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def update
    # No need to define @product here, it's already set by the before_action callback
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  private

  def current_order
    @current_order ||= current_user.orders.in_progress.last || current_user.orders.create(status: 'in_progress', order_date: Date.today)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:artisan_id, :name, :description, :price, :quantity_available, :image)
  end
end