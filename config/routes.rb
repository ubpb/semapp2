SemApp2::Application.routes.draw do

  # Admin routes
  namespace :admin do |admin|
    root to: 'sem_apps#index'

    resources :sem_apps, path: 'apps' do 
      collection do 
        post :filter
      end
      member do
        put :set_creator
      end
      resources :ownerships, shallow: true
    end

    resources :books, 
          only: [:edit, :update, :destroy, :defer, :dedefer, :placed_in_shelf, 
                  :removed_from_shelf, :reference] do
      member do
        put :defer
        put :dedefer
        put :placed_in_shelf
        put :removed_from_shelf
        put :reference
      end
    end

    resources :book_shelves, path: 'shelves', only: :index

    resources :scanjobs do
     member do 
       put :defer
       put :dedefer
     end
     collection do 
       put :upload
     end
    end

    match 'scanjobs/:id/print-job' => 'scanjobs#print_job', as: :scanjob_print_job
    match 'scanjobs/print-list/:list_name' => 'scanjobs#print_list', as: :scanjobs_print_list
    match 'scanjobs/:id/barcode' => 'scanjobs#barcode', as: :scanjob_barcode
  end

  resources :sessions, only: [:new, :create, :destroy]
  match 'login'  => 'sessions#new',     as: :login
  match 'logout' => 'sessions#destroy', as: :logout #, via: :delete

  # User profile
  resource :user, only: [:show]

  # Sem Apps
  match "semester"        => 'sem_apps#semester_index', as: :semester_index
  match 'semester/filter' => 'sem_apps#filter_semester_index', as: :filter_semester_index

  # resources :sem_apps, :path => 'apps', :controller => 'sem_apps', :member => {:unlock => :post, :transit => :post, :clones => :get, :clone => :post, :filter_clones => :post, :clear => :delete, :show_books => :get, :show_media => :get, :generate_access_token => :put}, :collection => {:filter => :post} do 
  resources :sem_apps, :path => 'apps' do 
    member do
      post :unlock
      post :transit
      get :clones
      post :clone
      post :filter_clones
      delete :clear
      get :show_books
      get :show_media
      put :generate_access_token
    end

    collection do 
      post :filter
    end

    resources :entries, only: [:reorder, :new], shallow: true do 
      collection do 
        put :reorder
      end
      resources :file_attachments, path: 'attachments', only: [:edit, :update, :destroy]
      resources :scanjobs, path: 'scans', only: [:edit, :update, :destroy]
    end
    resources :headline_entries, path: 'headlines', shallow: true do 
      # nope
    end
    resources :text_entries, path: 'texts', shallow: true do 
      resources :file_attachments, path: 'attachments', only: [:new, :create]
    end
    resources :monograph_entries, path: 'monographs', shallow: true do 
      resources :file_attachments, path: 'attachments', only: [:new, :create]
      resources :scanjobs, path: 'scans', only: [:new, :create]
    end
    resources :article_entries, path: 'articles', shallow: true do 
      resources :file_attachments, path: 'attachments', only: [:new, :create]
      resources :scanjobs, path: 'scans', only: [:new, :create]
    end
    resources :collected_article_entries, path: 'collected-articles', shallow: true do 
      resources :file_attachments, path: 'attachments', only: [:new, :create]
      resources :scanjobs, path: 'scans', only: [:new, :create]
    end
    resources :miless_file_entries, path: 'miless-files', shallow: true do 
      resources :file_attachments, path: 'attachments', only: [:new, :create]
    end

    resources :books
    resources :ownerships, :shallow => true
  end

  # Download (secured download of attachments)
  match 'download/:id/:style/*other' => 'download#download', :as => :download

  # Root Page
  root to: "home#index"

end
