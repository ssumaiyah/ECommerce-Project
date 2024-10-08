class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :initialize_session

  before_action :authenticate_user!

  private

  def set_current_cart
    @current_cart = (current_user.orders.find_or_create_by(status: "pending") if user_signed_in?)
  end

  def current_order
    return unless user_signed_in?

    @current_order ||= Order.find_by(user_id: current_user.id, status: "pending") ||
                       Order.create(user_id: current_user.id, status: "pending")
  end

  def initialize_session
    session[:shopping_cart] ||= {}
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:province_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:province_id])

    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
