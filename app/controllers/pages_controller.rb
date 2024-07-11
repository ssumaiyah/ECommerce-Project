class PagesController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end

  
  
    def about
      @page = Page.find_by(title: 'About')
      render :show
    end
  
    def contact
      @page = Page.find_by(title: 'Contact')
      render :show
    end
  end
  

