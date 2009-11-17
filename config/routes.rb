ActionController::Routing::Routes.draw do |map|

  # Admin routes
  map.namespace :admin do |admin|
    admin.dashboard 'dashboard', :controller => 'dashboard'
    admin.resources :semesters
    admin.resources :locations, :collection => {:reorder => :put}
    #admin.resources :sem_apps, :as => 'apps' do |sem_app|
    #  sem_app.resources :ownerships, :only => [:index, :create, :destroy]
    #  sem_app.resources :book_orders, :as => 'book-orders', :only => [:index, :new, :create, :destroy]
    #end
    admin.resources :users
    #admin.namespace :utils do |utils|
    #  utils.users_picker 'users_picker.:format', :controller => 'users_picker', :action => 'users_listing'
    #end
  end

  # Login / Logout
  map.resource :user_sessions
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'

  # User registration / User profiles
  map.resource :user, :except => [:index, :destroy], :collection => {:password => :get, :change_password => :put}

  # Sem Apps
  map.resources :sem_apps, :as => 'apps', :controller => 'sem_apps', :except => [:destroy] do |sem_app|
    sem_app.resources :entries, :controller => 'sem_app_entries', :except => [:index, :show], :collection => {:reorder => :put}
    sem_app.resources :books
  end

  # ubdok import
  map.ubdok_sem_apps_import 'ubdok_sem_apps_import', :controller => 'ubdok_import', :action => 'import_sem_apps'
  map.ubdok_sem_app_import 'ubdok_sem_app_import', :controller => 'ubdok_import', :action => 'import_sem_app'
  
  # Download (secured download of attachments)
  map.download 'download/:hash1/:hash2/:hash3/:id/:style', :controller => 'download', :action => 'download'

  # Root Page
  map.root :controller => "home"
end
