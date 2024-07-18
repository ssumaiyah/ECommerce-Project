class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :add_item_cart]

  def index
    @products = Product.page(params[:page]).per(10)
  end
  
  
  def show
    # Your existing show action code
  end

  def add_item_cart
    quantity = params[:quantity].to_i
    current_order.add_product(@product.id, quantity)
    redirect_to product_path(@product), notice: 'Product added to cart successfully!'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def current_order
    # Find or create the current order for the user with 'in_progress' status
    @current_order ||= current_user.orders.in_progress.last || current_user.orders.create(status: 'in_progress', order_date: Date.today)
  end

  
   
 

  def show
    @product = Product.find(params[:id])
  end

  def edit
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
  
  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
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
  end
  def show
    # Your existing show action code
  end

 

  private

  def product_params
    params.require(:product).permit(:artisan_id, :name, :description, :price, :quantity_available, :image)
  end
end
