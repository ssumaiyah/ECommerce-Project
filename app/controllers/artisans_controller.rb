class ArtisansController < ApplicationController
  def index
    @artisans = Artisan.page(params[:page]).per(10) # Adjust per(10) as needed
  end

  def show
    @artisan = Artisan.find(params[:id])
  end

  def new; end

  def edit; end
end
