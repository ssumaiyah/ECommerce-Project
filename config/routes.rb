Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get 'pages/home'
  get 'pages/about'

  resources :users
  resources :artisans
 root 'products#index'
resources :products, only: [:index, :show]

  resources :orders
  resources :order_items
  resources :categories
  resources :reviews
  resources :product_categories

  get "up" => "rails/health#show", as: :rails_health_check

  
end
