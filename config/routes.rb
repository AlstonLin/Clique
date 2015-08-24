Rails.application.routes.draw do
  resources :payment_notifications
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :orders

  post "/hook" => "orders#hook"
  post "/orders/:id" => "orders#show"

  resources :pins
  root "pins#index"

  get "user_pins" => "pins#user_pins"
  get "index" => "users#index"


resources :users, :path => do
  resources :pins
end




end