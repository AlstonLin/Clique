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
  # Settings custom routing
  get 'settings' => 'settings#index'
  get 'change_password' => 'settings#change_password'
  get 'clique_settings' => 'settings#clique_settings'
  get 'edit_profile' => 'settings#edit_profile'
  get 'orders' => 'settings#orders'
  get 'payment_settings' => 'settings#payment_settings'
  # Resources
  resources :users, :only => [:index, :show, :update], :path => 'profiles' do
    post 'follow'
    patch 'update_password'
    get 'posts'
    get 'reposts'
    get 'clique'
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
    :registrations => "registrations", :confirmations => "confirmations", :passwords => "passwords"}
  devise_scope :user do
    resources :passwords
  end
end
