ActionController::Routing::Routes.draw do |map|

  # Admin routes
  map.namespace :admin do |admin|
    admin.root :controller => 'sem_apps', :action => 'index'

    admin.resources :sem_apps, :as => 'apps', :collection => {:filter => :post}

    admin.resources :books, :only => [:defer, :dedefer, :placed_in_shelf, :removed_from_shelf], :member => {:defer => :put, :dedefer => :put, :placed_in_shelf => :put, :removed_from_shelf => :put}

    admin.resources :scanjobs

    #admin.resources :semesters
    #admin.resources :locations, :collection => {:reorder => :put}
    #admin.resources :sem_apps, :as => 'apps' do |sem_app|
    #  sem_app.resources :ownerships, :only => [:index, :create, :destroy]
    #  sem_app.resources :book_orders, :as => 'book-orders', :only => [:index, :new, :create, :destroy]
    #end
    #admin.resources :users
    #admin.namespace :utils do |utils|
    #  utils.users_picker 'users_picker.:format', :controller => 'users_picker', :action => 'users_listing'
    #end
  end

  # Login / Logout
  map.devise_for :user, :path_names => { :sign_in => 'login', :sign_out => 'logout' }

  # User profile
  map.resource :user, :only => [:show]

  # Sem Apps
  map.resources :sem_apps, :as => 'apps', :controller => 'sem_apps', :member => {:unlock => :post} do |sem_app|

    sem_app.resources :headline_entries,           :as => 'headlines',          :shallow => true
    sem_app.resources :text_entries,               :as => 'texts',              :shallow => true
    sem_app.resources :monograph_entries,          :as => 'monographs',         :shallow => true
    sem_app.resources :article_entries,            :as => 'articles',           :shallow => true
    sem_app.resources :collected_article_entries,  :as => 'collected-articles', :shallow => true

    sem_app.resources :entries, :only => [:reorder], :collection => {:reorder => :put}, :shallow => true

    sem_app.resources :books, :collection => {:lookup => :get}
  end

  # ubdok import
  #map.ubdok_sem_apps_import 'ubdok_sem_apps_import', :controller => 'ubdok_import', :action => 'import_sem_apps'
  #map.ubdok_sem_app_import 'ubdok_sem_app_import', :controller => 'ubdok_import', :action => 'import_sem_app'
  
  # Download (secured download of attachments)
  map.download 'download/:id/:style', :controller => 'download', :action => 'download'

  # Root Page
  map.root :controller => "home"
end
