Omrats::Application.routes.draw do


  root :to => "home#index"

  match '/admin', :to => 'admin/overview#index'
  match '/auth/:provider/callback' => 'authentications#create'

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
  end

end
