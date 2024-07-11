class CategoriesController < ApplicationController
  def index
    @categories = Category.page(params[:page]).per(10)
  end

  def show
    @category = Category.find(params[:id])
    @products = @category.products.page(params[:page]).per(10)
  end
  
  def new
  end

  def edit
  end
end
