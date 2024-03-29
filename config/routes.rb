Rails.application.routes.draw do

  # API routes
  namespace :api, defaults: {format: :json} do
    # Speacial Admin API routes
    namespace :admin do
      get :owners, to: "owners#index"
    end
  end

  # Admin routes
  namespace :admin do
    root to: 'sem_apps#index'

    get   :application_settings, to: 'application_settings#index'
    patch :application_settings, to: 'application_settings#update'

    resources :mailings, only: [:new, :create]

    resources :sem_apps, path: 'apps', except: [:new, :create] do
      collection do
        match :filter, via: [:get, :post]
      end
      member do
        put :set_creator
      end
      resources :ownerships, shallow: true
    end

    resources :books,
          only: [:edit, :update, :destroy, :defer, :dedefer, :placed_in_shelf,
                  :removed_from_shelf, :reference, :set_ebook_reference] do
      member do
        put :defer
        put :dedefer
        put :placed_in_shelf
        put :removed_from_shelf
        put :reference
        put :set_ebook_reference
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

    get "attachment-checks", to: "attachment_checks#index", as: :attachment_checks

    match 'scanjobs/:id/print-job' => 'scanjobs#print_job', as: :scanjob_print_job, via: [:get, :post]
    match 'scanjobs/print-list/:list_name' => 'scanjobs#print_list', as: :scanjobs_print_list, via: [:get, :post]
    match 'scanjobs/:id/barcode' => 'scanjobs#barcode', as: :scanjob_barcode, via: [:get, :post]
  end

  resources :sessions, only: [:new, :create, :destroy]
  match 'login'         => 'sessions#new',     as: :login, via: [:get, :post]
  match 'logout'        => 'sessions#destroy', as: :logout, via: :get
  get   'switch/:login' => 'sessions#switch'
  get   'switch-back'   => 'sessions#switch_back'

  # User profile
  resource :user, only: [:show]

  # Sem Apps
  match "semester"        => 'sem_apps#semester_index', as: :semester_index, via: [:get, :post]
  match 'semester/filter' => 'sem_apps#filter_semester_index', as: :filter_semester_index, via: [:get, :post]

  resources :sem_apps, :path => 'apps' do
    member do
      post :unlock
      get  :clones
      post :clone
      post :filter_clones
      put  :generate_access_token
      get  :export, to: 'export#export', as: :export
      get  :import, to: 'import#new',    as: :new_import
      post :import, to: 'import#create', as: :import
    end

    collection do
      post :filter
    end

    resource :transit, only: [:new, :create], controller: :sem_app_transits

    resources :books

    resources :ownerships, :shallow => true

    resources :media, only: [:reorder, :new], shallow: true do
      collection do
        put :reorder
      end
      resources :file_attachments, path: 'attachments', only: [:edit, :update, :destroy]
      resources :scanjobs, path: 'scans', only: [:edit, :update, :destroy]
    end
    resources :media_headlines, path: 'headlines', shallow: true do
      # nope
    end
    resources :media_texts, path: 'texts', shallow: true do
      resources :file_attachments, path: 'attachments', only: [:new, :create]
    end
    resources :media_monographs, path: 'monographs', shallow: true do
      resources :file_attachments, path: 'attachments', only: [:new, :create]
      resources :scanjobs, path: 'scans', only: [:new, :create]
    end
    resources :media_articles, path: 'articles', shallow: true do
      resources :file_attachments, path: 'attachments', only: [:new, :create]
      resources :scanjobs, path: 'scans', only: [:new, :create]
    end
    resources :media_collected_articles, path: 'collected-articles', shallow: true do
      resources :file_attachments, path: 'attachments', only: [:new, :create]
      resources :scanjobs, path: 'scans', only: [:new, :create]
    end
  end

  # Download (secured download of attachments)
  match 'download/:id/:style/*other' => 'download#download', :as => :download, via: [:get, :post]

  # Static links
  get '/datenschutz', to: redirect("https://www.ub.uni-paderborn.de/fileadmin/ub/Dokumente_Formulare/DSE_UB_003_Seminarapparate.pdf")

  # Root Page
  root to: "home#index"

end
