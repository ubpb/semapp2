# encoding: utf-8

class Admin::SemAppsController < Admin::ApplicationController

  SEM_APP_FILTER_NAME = 'admin_sem_app_filter_name'.freeze

  def index
    @filter = session[SEM_APP_FILTER_NAME] || SemAppsFilter.new
    if @filter
      @sem_apps = @filter.scope.paginate(:all, :include => [:creator, :books],  :per_page => 10, :page => params[:page],
        :order => "sem_apps.approved asc, books.state asc")
    else
      @sem_apps = SemApp.paginate(:all, :include => [:creator, :books], :per_page => 10, :page => params[:page],
        :order => "sem_apps.approved asc, books.state asc")
    end
  end

  def filter
    filter = SemAppsFilter.new(params[:filter])
    session[SEM_APP_FILTER_NAME] = filter
    redirect_to :action => :index
  end

  def show
    @sem_app        = SemApp.find_by_id(params[:id])
    (flash[:error] = "Dieser Apparat existiert nicht"; redirect_to admin_sem_apps_path) unless @sem_app.present?

    @ordered_books  = Book.for_sem_app(@sem_app).ordered.ordered_by('created_at')
    @removed_books  = Book.for_sem_app(@sem_app).removed.ordered_by('created_at')
    @deferred_books = Book.for_sem_app(@sem_app).deferred.ordered_by('created_at')

    respond_to do |format|
      format.html { render 'show',  :format => 'html' }
      format.print { render 'show', :format => 'print', :layout => 'print' }
    end
  end

  def new
    @sem_app = SemApp.new
    @sem_app.build_book_shelf unless @sem_app.book_shelf.present?
  end

  def create
    @sem_app = SemApp.new(params[:sem_app])
    @sem_app.creator = current_user
    if @sem_app.save
      flash[:success] = "Der Seminarapparat wurde erfolgreich erstellt"
      redirect_to :action => :index
    else
      @sem_app.build_book_shelf unless @sem_app.book_shelf.present?
      render :action => :new
    end
  end

  def edit
    @sem_app = SemApp.find(params[:id])
    @sem_app.build_book_shelf unless @sem_app.book_shelf.present?
  end

  def update
    @sem_app = SemApp.find(params[:id])
    
    was_approved = @sem_app.approved

    if @sem_app.update_attributes(params[:sem_app])
      if (@sem_app.approved and not was_approved)
        Notifications.deliver_sem_app_activated_notification(@sem_app.creator, @sem_app)
      end
      flash[:success] = "Die Daten wurden erfolgreich gespeichert"
      redirect_to :action => :show
    else
      render :action => :edit
    end
  end

end
