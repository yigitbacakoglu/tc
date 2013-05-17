Omrats::Application.routes.draw do


  match 'sitemap.xml' => 'sitemaps#sitemap'

  root :to => "home#index"
  get "/maintenance", :to => "home#maintenance"
  get '/close', :to => "widgets#close", :as => :close
  get '/ping', :to => "home#ping", :as => :ping
  get '/demo', :to => "widgets#demo", :as => :demo
  get '/demo-1', :to => "widgets#demo", :as => :demo2
  get '/demo-2', :to => "widgets#demo", :as => :demo3
  match '/admin', :to => 'admin/overview#index', :as => :admin
  match '/auth/:provider/callback' => 'authentications#create'

  get '/sale', :to => "blogs#sale", :as => :sale
  post '/domain/offer', :to => "blogs#save_contact_info", :as => :save_contact_info
  resources :widgets


  get '/setup', :to => "setup#new", :as => :new_setup
  get '/setup/:id', :to => "setup#show", :as => :setup
  post '/setup', :to => "setup#create", :as => :create_setup

  get '/share/twitter', :to => "social#twitter", :as => :share_twitter
  get '/share/facebook', :to => "social#facebook", :as => :share_facebook

  resources :posts do
    collection do
      post :rate
      post :flag
      post :comment
    end
  end
  resources :comments

  devise_for :user_registrations,
             :path => '/authenticate',
             :path_names => {:sign_in => "/login", :sign_out => "/logout", :sign_up => "/register"},
             :controllers => {:sessions => "user_sessions",
                              :registrations => "user_registrations",
                              :passwords => "user_passwords"
             }
  resources :authentications

  namespace :admin do

    get "/set_store/:store_id", :to => "overview#set_session_store", :as => :change_store
    get "/change_widget/:widget_id", :to => "overview#set_session_widget", :as => :change_widget
    get "/change_post/:post_id", :to => "overview#set_post", :as => :change_post
    resources :overview
    resources :secrets
    resources :categories

    resources :users do
      member do
        put :ban
        put :allow
      end
    end

    resources :settings do
      collection do
        put :update_restricted_words
      end
    end

    resources :comments do
      collection do
        get "set_all/:state", :as => :set_all, :to => "comments#set_all"
      end
    end

    resources :account, :except => [:show, :index]

    get '/account', :as => :account, :to => 'account#show'
    put '/account', :as => :update_account, :to => 'account#update'
    resources :widgets  do
      member do
        delete :delete_domain
      end
    end
    get '/fire/:e/comment/:comment_id', :as => :fire, :to => 'overview#fire'
  end

end
