Rails.application.routes.draw do
  devise_for :users, controllers: {
  sessions: 'users/sessions',
  registrations: 'users/registrations'
}


  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'

  resources :products, only: [:index, :show, :edit, :update, :search] do
    post 'add_item_cart', on: :member
    collection do
      get 'search', to: 'products#search', as: 'search'
    end
  end

  
  resource :cart, only: [:show] do
    collection do
      post 'add_item'
      patch 'update_item/:id', to: 'carts#update_item', as: 'update_item'
      delete 'remove_item/:id', to: 'carts#remove_item', as: 'remove_item'
      get 'checkout'
      post 'place_order'
    end
  end
  

  resources :orders, only: [:show] do
    member do
      patch 'update_item/:id', to: 'orders#update_item', as: 'update_item'
      delete 'remove_item/:id', to: 'orders#remove_item', as: 'remove_item'
    end
  end

  resources :users
  resources :artisans
  resources :order_items
  resources :categories
  resources :reviews
  resources :product_categories

  get 'up', to: 'rails/health#show', as: :rails_health_check
  root 'products#index'
  resources :pages, only: [:show]
end
