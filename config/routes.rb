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
  get "payment" => "home#payment"
  get "all" => "home#all"
  get "explore" => "home#explore"
  get "tracks" => "home#tracks"
  get "posts" => "home#posts"
  get "cliques" => "home#cliques"
  get "favorites" => "home#favorites"
  # Settings routes
  get 'settings' => 'settings#account_settings'
  get 'change_password' => 'settings#account_settings'
  get 'payment_settings' => 'settings#payment_settings'
  get 'clique_settings' => 'settings#clique_settings'
  get 'edit_profile' => 'settings#edit_profile'
  get 'orders' => 'settings#orders'
  get 'edit_clique' => 'settings#edit_clique'
  get 'clique_members' => 'settings#clique_members'
  post 'setup_payment' => 'settings#setup_payment'
  # Dashboard routes
  get "dashboard" => "dashboard#main"
  get "dashboard_monthly" => "dashboard#monthly", :path => 'dashboard/monthly'
  get "dashboard_daily" => "dashboard#daily", :path => 'dashboard/daily'
  get "dashboard_tracks" => "dashboard#tracks", :path => 'dashboard/tracks'
  get "dashboard_orders" => "dashboard#orders", :path => 'dashboard/orders'

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
