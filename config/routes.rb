Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'pages/about'
  resources :products do
    post 'add_item_cart', on: :member
  end
  resource :cart, only: [:show] do
    post 'add/:product_id', to: 'carts#add', as: 'add_item'
    patch 'update/:order_item_id', to: 'carts#update', as: 'update_item'
    delete 'remove/:order_item_id', to: 'carts#remove', as: 'remove_item'
  end
  resources :cart, only: [:show]
  resources :users
  resources :artisans
  root 'products#index'
  resources :pages, only: [:show]
  resources :products, only: [:index, :show, :edit, :update] do
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
