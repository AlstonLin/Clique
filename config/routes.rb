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
  get "all" => "home#all"
  get "explore" => "home#explore"
  get "tracks" => "home#tracks"
  get "posts" => "home#posts"
  get "cliques" => "home#cliques"
  get "favorites" => "home#favorites"
  # Dashboard routes
  get "dashboard" => "dashboard#main"
  get "dashboard_monthly" => "dashboard#monthly", :path => 'dashboard/monthly'
  get "dashboard_daily" => "dashboard#daily", :path => 'dashboard/daily'
  get "dashboard_tracks" => "dashboard#tracks", :path => 'dashboard/tracks'
  get "dashboard_orders" => "dashboard#orders", :path => 'dashboard/orders'
  get "dashboard_subscriptions" => "dashboard#subscriptions", :path => 'dashboard/subscriptions'
  get "dashboard_subscribers" => "dashboard#subscribers", :path => 'dashboard/subscribers'
  get 'dashboard_account' => 'dashboard#account', :path => 'dashboard/account'
  get 'edit_profile' => 'dashboard#edit_profile', :path => 'dashboard/account'
  get 'change_password' => 'dashboard#change_password'
  get 'payment_settings' => 'dashboard#payment_settings'
  get 'clique_settings' => 'dashboard#clique_settings'
  post 'setup_payment' => 'dashboard#setup_payment'
  # Search routes
  get 'search' => 'search#search', :path => 'search'
  # Resources
  resources :users, :only => [:index, :show, :update], :path => 'profile' do
    post 'follow'
    patch 'update_password'
    get 'message'
    get 'all'
    get 'posts'
    get 'clique'
    get 'tracks'
    get 'followers'
    get 'following'
  end
  resources :tracks, :only => [:new, :create, :show] do
    post 'delete'
    post 'repost'
    post 'favorite'
    post 'load_modal'
  end
  resources :posts, :only => [:create, :update] do
    post 'delete'
    post 'repost'
    post 'favorite'
    post 'load_modal'
  end
  resources :cliqs, :only => [:create, :update], :path => 'clique' do
    get 'payment'
    post 'join'
    post 'leave'
  end
  resources :messages, :only => [:index, :new, :create]
  resources :conversations, :only => [:show]
  resources :notifications, :only => [:index]
  resources :comments, :only => :create do
    post 'delete'
  end
  resources :downloads, :only => :create
  # Auth
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "registrations", :confirmations => "confirmations", :passwords => "passwords"}
  devise_scope :user do
    resources :passwords, :only => [:new, :create, :edit, :update]
  end
end
