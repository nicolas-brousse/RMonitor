RMonitor::Application.routes.draw do

  devise_for :users

  get    "/users/:id"       => "users#show"
  get    "/users/:id/edit"  => "users#edit"
  put    "/users/:id"       => "users#update"
  delete "/users/:id"       => "users#destroy"

  get "/dashboard"  => "index#dashboard", :as => :dashboard

  resources :servers, :path_names => {:edit => "settings"}

  get "servers/:server_id/monitorings"                => "monitorings#index", :as => :servers_monitorings#,         :constraints => {:server_id => /\d+/}
  get "servers/:server_id/monitorings/:protocol_type" => "monitorings#show",  :as => :servers_monitorings_history#, :constraints => {:server_id => /\d+/}

  namespace :admin do
    get  "/"           => "index#index"
    get  "/info"       => "index#info"
    get  "/servers"    => "index#servers"
    get  "/settings"   => "index#settings"
    post "/settings"   => "index#settings_save", :as => :edit_settings
  end

  namespace :api, :defaults => {:format => :json} do
    get "/"       => "index#index"
  end

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
