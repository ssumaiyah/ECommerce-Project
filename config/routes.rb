Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'pages/about'

  

  resources :users
  resources :artisans
  root 'products#index'
  resources :pages, only: [:show]
  resources :products, only: [:index, :show] do
    collection do
      get 'search', to: 'products#search', as: 'search'
    end
  end

  resources :orders
  resources :order_items
  resources :categories
  resources :reviews
  resources :product_categories

  get "up" => "rails/health#show", as: :rails_health_check
end
