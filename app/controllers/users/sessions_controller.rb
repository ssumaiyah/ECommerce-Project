# app/controllers/users/sessions_controller.rb

class Users::SessionsController < Devise::SessionsController
  def destroy
    super
  end
end
