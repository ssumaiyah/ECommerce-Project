class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :initialize_session



  private

  def set_current_cart
    if user_signed_in?
      @current_cart = current_user.orders.find_or_create_by(status: 'pending')
    else
      @current_cart = nil
    end
  end

  private

  def current_order
    if user_signed_in?
      @current_order ||= Order.find_by(user_id: current_user.id, status: 'pending') ||
                         Order.create(user_id: current_user.id, status: 'pending')
    end
  end
def authenticate_user!
    unless user_signed_in?
      flash[:alert] = "You need to sign in or sign up before continuing."
      redirect_to new_user_session_path
    end
  end
 
  private

  def initialize_session
    session[:shopping_cart] ||= {}
  end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:province_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:province_id])
  end
end



  

