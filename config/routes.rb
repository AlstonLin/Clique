Rails.application.routes.draw do
  # Root
  authenticated :user do
    root to: "tracks#index", :as => :authenticated_root
  end
  unauthenticated do
    root to: "landing_page#index"
  end
  # Resources
  resources :users, :only => [:index, :show], :path => '/profiles' do
  end
  resources :tracks, only: [:index, :new, :create]
  # Auth
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "registrations", :confirmations => "confirmations",
    :passwords => "passwords"}
end
