# -*- encoding : utf-8 -*-
Exview::Application.routes.draw do
  match "/oauth/create", :to => "oauth#create", :via => "get", :as => "oauth_callback"

  resources :photos, :only => [:new, :create, :show]

  match 'about' => 'welcome#about', :as => :about
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'assign' => 'assigns#create', :as => :assign
  match '/activate/:activation_code' => 'activations#create', :as => :activate

  resources :password_resets, :only => [ :new, :create, :edit, :update ]
  resource :user_session
  resources :users do
    member do
      #get 'wall'
      get 'assigned'
    end

    collection do
      get 'resend_activation'
    end

    resources :messages do
      collection do
        post :delete_selected
      end
    end
  end
  resources :comments, :except => [:index, :show, :edit, :update]

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
  root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
