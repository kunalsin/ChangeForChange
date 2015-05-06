BreadExpress::Application.routes.draw do

  # Routes for main resources
  resources :addresses
  resources :customers
  resources :orders
  resources :items
  resources :sessions
  resources :users

  
  # Authentication routes
  get 'user/edit' => 'customers#edit', as: :edit_current_user
  get 'signup' => 'customers#new', as: :signup
  get 'logout' => 'sessions#destroy', as: :logout
  get 'login' => 'sessions#new', as: :login

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'search' => 'home#search', as: :search
  get 'cylon' => 'errors#cylon', as: :cylon
  
  # Set the root url
  root :to => 'home#home'  
  
  # Named routes
  post 'items/:id/add_to_cart' => 'items#add_to_cart', as: :add_to_cart
  post 'items/:id/remove_from_cart' => 'items#remove_from_cart', as: :remove_from_cart
  get 'cart' => 'items#cart', as: :cart
  post 'checkout' => 'orders#new', as: :checkout
  patch 'mark-shipped/:id' => 'home#mark_shipped', as: :mark_shipped
  patch 'mark-unshipped/:id' => 'home#mark_unshipped', as: :mark_unshipped
  
  # Last route in routes.rb that essentially handles routing errors
  get '*a', to: 'errors#routing'
end
