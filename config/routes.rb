ActionController::Routing::Routes.draw do |map|

  # Admin routes
  map.namespace :admin do |admin|
    admin.resources :semesters
    admin.resources :sem_apps, :has_many => :ownerships
  end

  # Login / Logout
  map.resource :user_sessions
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'

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
