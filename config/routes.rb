RMonitor::Application.routes.draw do

  devise_for :users#, :skip =>  [:registrations, :confirmations]

  get "/my/preferences" => "users#settings",        :as => :user_preferences
  put "/my/preferences" => "users#settings_save"
  get "/my/account"     => "users#edit",            :as => :user_account, :defaults => {:id => 'my'}
  get "/my/password"    => "devise/passwords#edit", :as => :edit_user_password
  put "/my/password"    => "devise/passwords#update"

  get    "/users/new"       => "users#new",    :as => :new_user
  post   "/users/create"    => "users#create", :as => :create_user
  get    "/users/:id"       => "users#show",   :as => :user
  get    "/users/:id/edit"  => "users#edit",   :as => :edit_user
  # put    "/users/:id"       => "users#update"
  # delete "/users/:id"       => "users#destroy"

  resources :servers, :path_names => {:edit => "settings"} do
    resources :incidents, :path_names => {:edit => "edit"}
  end

  get "servers/:server_id/monitorings"                => "monitorings#index", :as => :servers_monitorings#,         :constraints => {:server_id => /\d+/}
  get "servers/:server_id/monitorings/:protocol_type" => "monitorings#show",  :as => :servers_monitorings_history#, :constraints => {:server_id => /\d+/}

  namespace :admin do
    get  "/"           => "index#index"
    get  "/info"       => "index#info"
    get  "/servers"    => "index#servers"
    get  "/users"      => "index#users"
    get  "/settings"   => "index#settings"
    post "/settings"   => "index#settings_save", :as => :edit_settings
  end

  namespace :api, :defaults => {:format => :json} do
    get "/"       => "index#index"
  end

  get "/dashboard"  => "index#dashboard", :as => :dashboard

  root :to => "index#index"

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
