Rails.application.routes.draw do
  get 'tracks/index'

  get 'tracks/create'

  # Root
  authenticated :user do
    root to: "streams#index", :as => :authenticated_root
  end
  unauthenticated do
    root to: "landing_page#index"
  end
  # Resources
  resources :users, :only => [:show], :path => '/profiles'
  resources :streams
  resources :tracks, only: [:index, :create]
  # Auth
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "registrations", :confirmations => "confirmations",
    :passwords => "passwords"}
end
