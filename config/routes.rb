ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # Sem Apps
  map.resources :sem_apps, :as => 'semapps', :controller => 'sem_apps', :only => [:index, :show] do |sem_app|
    sem_app.resources :entries, :controller => 'sem_app_entries', 
      :only => [:show, :new, :create, :edit, :update, :destroy], :collection => {:reorder => :put}
  end

  # ubdok import
  map.ubdok_sem_apps_import 'ubdok_sem_apps_import', :controller => 'ubdok_import', :action => 'import_sem_apps'
  map.ubdok_sem_app_import 'ubdok_sem_app_import', :controller => 'ubdok_import', :action => 'import_sem_app'
  
  # Download (secured download of attachments)
  map.download 'download/:hash1/:hash2/:hash3/:id/:style', :controller => 'download', :action => 'download'

  # Root Page
  map.root :controller => "home"
end
