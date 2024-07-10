Rails.application.routes.draw do
  get 'product_categories/index'
  get 'product_categories/show'
  get 'product_categories/new'
  get 'product_categories/edit'
  get 'reviews/index'
  get 'reviews/show'
  get 'reviews/new'
  get 'reviews/edit'
  get 'categories/index'
  get 'categories/show'
  get 'categories/new'
  get 'categories/edit'
  get 'order_items/index'
  get 'order_items/show'
  get 'order_items/new'
  get 'order_items/edit'
  get 'orders/index'
  get 'orders/show'
  get 'orders/new'
  get 'orders/edit'
  get 'products/index'
  get 'products/show'
  get 'products/new'
  get 'products/edit'
  get 'artisans/index'
  get 'artisans/show'
  get 'artisans/new'
  get 'artisans/edit'
  get 'users/index'
  get 'users/show'
  get 'users/new'
  get 'users/edit'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
