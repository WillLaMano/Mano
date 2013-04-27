Mano::Application.routes.draw do
  get "activations/create"

  match 'authorizations/callback/:provider'=>"authorizations#callback"
  match 'authorizations/new/:provider'=>"authorizations#new"
  resources :authorizations


  resources :user_sessions
  resources :authentications
  resources :static_pages

  resources :group_invitations, :only => ["create"]
  match 'groups/join/:token' => "groups#invited", :as => :invited_to_group, :via => :get
  match 'groups/join/:token' => "groups#join", :as => :join_group, :via => :post
  match 'groups/:id/leave' => "groups#leave", :as => :leave_group, :via => :delete
  match 'groups/:id/invite' => "group_invitations#new", :as => :new_group_invitation, :via => :get
  match 'groups/:id/current_status'=>"page#current_status"
  resources :groups 
  
  match 'login' => "user_sessions#new",      :as => :login
  match 'logout' => "user_sessions#destroy", :as => :logout
  match '/activate/:activation_code' => "activations#create", :as => :activate
resources :users do
  collection do
    get 'resend_activation'
  end
end
resources :password_resets, :only => [:new, :create,:edit, :update]

  resources :users  # give us our some normal resource routes for users
  resource :user, :as => 'account'  # a convenience route

  match 'signup' => 'users#new', :as => :signup
  
  match 'user/:id' => 'users#show'

  root :to => "static_pages#index"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
