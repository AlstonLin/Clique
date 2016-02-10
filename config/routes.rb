Rails.application.routes.draw do
  # Root
  authenticated :user do
    root to: "tracks#index", :as => :authenticated_root
  end
  unauthenticated do
    root to: "landing_page#index"
  end
  # Custom routes
  get "explore" => "tracks#explore"
  get "followed" => "tracks#followed"
  get "cliques" => "tracks#cliques"
  # Resources
  resources :users, :only => [:index, :show], :path => 'profiles' do
    post 'follow'
    get 'songs'
    get 'followers'
    get 'following'
  end
  resources :tracks, :only => [:index, :new, :create, :destroy]
  resources :cliqs, :only => [:new, :create, :show], :path => 'cliques' do
    post 'join'
  end
  # Auth
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "registrations", :confirmations => "confirmations",
    :passwords => "passwords"}
end
