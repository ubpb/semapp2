ActionController::Routing::Routes.draw do |map|

  # Admin routes
  map.namespace :admin do |admin|
    admin.resources :org_units, :collection => {:reorder => :put}
    admin.resources :semesters
    admin.resources :sem_apps, :as => 'apps' do |sem_app|
      sem_app.resources :ownerships, :only => [:index, :create, :destroy]
    end
    admin.resources :users
  end

  # Login / Logout
  map.resource :user_sessions
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'

  # User registration / User profiles
  map.resource :user

  # Sem Apps
  map.resources :sem_apps, :as => 'apps', :controller => 'sem_apps', :only => [:index, :show, :new, :create] do |sem_app|
    sem_app.resources :entries, :controller => 'sem_app_entries', 
      :except => [:index], :collection => {:reorder => :put}
  end

  # ubdok import
  map.ubdok_sem_apps_import 'ubdok_sem_apps_import', :controller => 'ubdok_import', :action => 'import_sem_apps'
  map.ubdok_sem_app_import 'ubdok_sem_app_import', :controller => 'ubdok_import', :action => 'import_sem_app'
  
  # Download (secured download of attachments)
  map.download 'download/:hash1/:hash2/:hash3/:id/:style', :controller => 'download', :action => 'download'

  # Root Page
  map.root :controller => "home"
end
