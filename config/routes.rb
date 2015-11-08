Rails.application.routes.draw do
  get 'tweets/new'

  get 'tweets/create'
  get 'tweets/show'
  get 'home/show'

  resources :payment_notifications

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks'}

  resources :tweets
  resources :orders

  post "/hook" => "orders#hook"
  post "/orders/:id" => "orders#show"

  resources :pins
  root "pins#index"

  get "user_pins" => "pins#user_pins"
  get "index" => "users#index"


resources :users, :path => '' do
  resources :pins
end





end