Rails.application.routes.draw do
  # Root
  authenticated :user do
    root to: "home#index", :as => :authenticated_root
  end
  unauthenticated do
    root to: "landing_page#index"
  end
  # Home Page routes
  get "home" => "home#index"
  get "explore" => "home#explore"
  get "tracks" => "home#tracks"
  get "posts" => "home#posts"
  get "cliques" => "home#cliques"
  # Settings custom routing
  get 'settings' => 'settings#index'
  get 'change_password' => 'settings#change_password'
  get 'clique_settings' => 'settings#clique_settings'
  get 'edit_profile' => 'settings#edit_profile'
  get 'orders' => 'settings#orders'
  get 'payment_settings' => 'settings#payment_settings'
  # Resources
  resources :users, :only => [:index, :show, :update], :path => 'profile' do
    post 'follow'
    post 'unfollow'
    patch 'update_password'
    get 'posts'
    get 'reposts'
    get 'clique'
    get 'songs'
    get 'followers'
    get 'following'
  end
  resources :tracks, :only => [:new, :create, :destroy]
  resources :posts, :only => [:create, :update]
  resources :cliqs, :only => [:create, :update], :path => 'clique' do
    post 'join'
  end
  # Auth
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "registrations", :confirmations => "confirmations", :passwords => "passwords"}
  resources :passwords
end
