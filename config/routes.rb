# frozen_string_literal: true

Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'pages#home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # To support Devise for User management
  devise_scope :user do
    # Redirects signing out users back to sign-in
    get 'users', to: 'devise/sessions#new'
  end
  devise_for :users

  # Routes for Rooms
  resources :rooms do
    resources :messages
  end

  # Custom routes for users
  get 'user/:id', to: 'users#show', as: 'user'
end
