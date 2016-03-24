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
  # Settings routes
  get 'settings' => 'settings#account_settings'
  get 'change_password' => 'settings#change_password'
  get 'clique_settings' => 'settings#clique_settings'
  get 'edit_profile' => 'settings#edit_profile'
  get 'orders' => 'settings#orders'
  get 'payment_settings' => 'settings#payment_settings'
  get 'edit_clique' => 'settings#edit_clique'
  get 'clique_members' => 'settings#clique_members'
  get 'clique_orders' => 'settings#clique_orders'
  # Resources
  resources :users, :only => [:index, :show, :update], :path => 'profile' do
    post 'follow'
    patch 'update_password'
    get 'all'
    get 'posts'
    get 'clique'
    get 'songs'
    get 'followers'
    get 'following'
  end
  resources :tracks, :only => [:new, :create, :destroy, :show] do
    post 'repost'
    post 'favorite'
  end
  resources :posts, :only => [:create, :update] do
    post 'delete'
    post 'repost'
    post 'favorite'
  end
  resources :cliqs, :only => [:create, :update], :path => 'clique' do
    post 'join'
    get 'joined'
    post 'leave'
  end
  resources :messages, :only => [:index, :new, :create]
  resources :conversations, :only => [:show]
  resources :post_comments, :only => :create
  resources :track_comments, :only => :create
  # Auth
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "registrations", :confirmations => "confirmations", :passwords => "passwords"}
  devise_scope :user do
    resources :passwords, :only => [:new, :create, :edit, :update]
  end
end
