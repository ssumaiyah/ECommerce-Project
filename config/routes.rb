Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'

  resources :products, only: [:index, :show, :edit, :update] do
    post 'add_item_cart', on: :member
    collection do
      get 'search', to: 'products#search', as: 'search'
    end
  end

  resource :cart, only: [:show] do
    post 'add_item/:product_id', action: :add_item, as: 'add_item'
    patch 'update_item/:order_item_id', action: :update_item, as: 'update_item'
    delete 'remove_item/:order_item_id', action: :remove_item, as: 'remove_item'
  end

  resources :orders, only: [:show]
  get 'orders/:id', to: 'orders#show', as: 'order_details'


  resources :users
  resources :artisans
  root 'products#index'
  resources :pages, only: [:show]
  resources :order_items
  resources :categories
  resources :reviews
  resources :product_categories

  get 'up', to: 'rails/health#show', as: :rails_health_check
end
