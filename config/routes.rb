Omrats::Application.routes.draw do


  match 'sitemap.xml' => 'sitemaps#sitemap'

  root :to => "home#index"
  get '/demo', :to => "widgets#demo", :as => :demo
  get '/demo-1', :to => "widgets#demo", :as => :demo2
  get '/demo-2', :to => "widgets#demo", :as => :demo3
  match '/admin', :to => 'admin/overview#index', :as => :admin
  match '/auth/:provider/callback' => 'authentications#create'

  get '/sale', :to => "blogs#sale", :as => :sale
  post '/domain/offer', :to => "blogs#save_contact_info", :as => :save_contact_info
  resources :widgets

  resources :posts do
    collection do
      post :rate
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
    resources :overview
    resources :account, :except => [:show, :index]
    get '/account', :as => :account, :to => 'account#show'
    put '/account', :as => :update_account, :to => 'account#update'
    resources :widgets
  end

end
