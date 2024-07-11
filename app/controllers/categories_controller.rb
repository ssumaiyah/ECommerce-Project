class CategoriesController < ApplicationController
  def index
  end

  def show
    @category = Category.find(params[:id])
    @products = @category.products.paginate(page: params[:page], per_page: 10)
  end
  
  def new
  end

  def edit
  end
end
