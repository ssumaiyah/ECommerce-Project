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
  
  private

  def product_params
    params.require(:product).permit(:artisan_id, :name, :description, :price, :quantity_available)
  end
end
