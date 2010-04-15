# encoding: utf-8

ActionController::Routing::Routes.draw do |map|

  # Admin routes
  map.namespace :admin do |admin|
    admin.root :controller => 'sem_apps', :action => 'index'

    admin.resources :sem_apps, :as => 'apps', :collection => {:filter => :post}, :member => {:set_creator => :put} do |sem_app|
      sem_app.resources :ownerships, :shallow => true
    end

    admin.resources :books, :only => [:edit, :update, :destroy, :defer, :dedefer, :placed_in_shelf, :removed_from_shelf, :reference], :member => {:defer => :put, :dedefer => :put, :placed_in_shelf => :put, :removed_from_shelf => :put, :reference => :put}
    admin.resources :book_shelves, :as => 'shelves', :only => [:index]

    admin.resources :scanjobs, :member => {:defer => :put, :dedefer => :put}, :collection => {:upload => :put}
    admin.scanjob_print_job   'scanjobs/:id/print-job',         :controller => 'scanjobs', :action => 'print_job'
    admin.scanjobs_print_list 'scanjobs/print-list/:list_name', :controller => 'scanjobs', :action => 'print_list'
    admin.scanjob_barcode     'scanjobs/:id/barcode',           :controller => 'scanjobs', :action => 'barcode'
  end

  # Login / Logout
  map.devise_for :user, :path_names => { :sign_in => 'login', :sign_out => 'logout' }

  # User profile
  map.resource :user, :only => [:show]

  # Sem Apps
  map.semester_index        'semester',        :controller => 'sem_apps', :action => 'semester_index'
  map.filter_semester_index 'semester/filter', :controller => 'sem_apps', :action => 'filter_semester_index'

  map.resources :sem_apps, :as => 'apps', :controller => 'sem_apps', :member => {:unlock => :post, :transit => :post, :clones => :get, :clone => :post, :filter_clones => :post, :clear => :delete, :show_books => :get, :show_media => :get, :generate_access_token => :put}, :collection => {:filter => :post} do |sem_app|
    sem_app.resources :entries, :only => [:reorder, :new], :collection => {:reorder => :put}, :shallow => true do |entry|
      entry.resources :file_attachments, :as => 'attachments', :only => [:edit, :update, :destroy]
      entry.resources :scanjobs, :as => 'scans', :only => [:edit, :update, :destroy]
    end
    sem_app.resources :headline_entries, :as => 'headlines', :shallow => true do |entry|
      # nope
    end
    sem_app.resources :text_entries, :as => 'texts', :shallow => true do |entry|
      entry.resources :file_attachments, :as => 'attachments', :only => [:new, :create]
    end
    sem_app.resources :monograph_entries, :as => 'monographs', :shallow => true do |entry|
      entry.resources :file_attachments, :as => 'attachments', :only => [:new, :create]
      entry.resources :scanjobs, :as => 'scans', :only => [:new, :create]
    end
    sem_app.resources :article_entries, :as => 'articles', :shallow => true do |entry|
      entry.resources :file_attachments, :as => 'attachments', :only => [:new, :create]
      entry.resources :scanjobs, :as => 'scans', :only => [:new, :create]
    end
    sem_app.resources :collected_article_entries,  :as => 'collected-articles', :shallow => true do |entry|
      entry.resources :file_attachments, :as => 'attachments', :only => [:new, :create]
      entry.resources :scanjobs, :as => 'scans', :only => [:new, :create]
    end
    sem_app.resources :miless_file_entries,  :as => 'miless-files', :shallow => true do |entry|
      entry.resources :file_attachments, :as => 'attachments', :only => [:new, :create]
    end

    sem_app.resources :books
  end
  
  # Download (secured download of attachments)
  map.download 'download/:id/:style/*other', :controller => 'download', :action => 'download'

  # Root Page
  map.root :controller => "home"
end
