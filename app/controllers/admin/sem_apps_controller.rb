class Admin::SemAppsController < Admin::ApplicationController

  SEM_APP_FILTER_NAME = 'admin_sem_app_filter_name'.freeze

  def index
    @filter = session[SEM_APP_FILTER_NAME] || SemAppsFilter.new
    if @filter
      @sem_apps = @filter.scope.paginate(:all, :include => [:creator, :books],  :per_page => 30, :page => params[:page], 
        :order => "sem_apps.approved asc, books.scheduled_for_addition asc, books.scheduled_for_removal asc, sem_apps.title desc")
    else
      @sem_apps = SemApp.paginate(:all, :include => [:creator, :books], :per_page => 30, :page => params[:page], 
        :order => "sem_apps.approved asc, books.scheduled_for_addition asc, books.scheduled_for_removal asc, sem_apps.title desc")
    end
  end

  def filter
    filter = SemAppsFilter.new(params[:filter])
    session[SEM_APP_FILTER_NAME] = filter
    redirect_to :action => :index
  end

  def show
    @sem_app = SemApp.find_by_id(params[:id])
    (flash[:error] = "Dieser Apparat existiert nicht"; redirect_to admin_sem_apps_path) unless @sem_app.present?

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
      flash[:success] = "Der eSeminarapparat wurde erfolgreich erstellt"
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
    if @sem_app.update_attributes(params[:sem_app])
      flash[:success] = "Die Daten wurden erfolgreich gespeichert"
      redirect_to :action => :show
    else
      render :action => :edit
    end
  end

#  resource_controller
#
#  new_action.before do
#  end
#
#  create do
#    wants.html {redirect_to :action => 'index'}
#    flash "eSeminarapparat erfolgreich erstellt"
#  end
#
#  edit.before do
#  end
#
#  update do
#    wants.html {redirect_to :action => 'index'}
#    flash "eSeminarapparat erfolgreich aktualisiert"
#  end
#
#  destroy do
#    flash "eSeminarapparat erfolgreich gelöscht"
#  end
#
#  private
#
#  def collection
#    conditions = {}
#    # state filters
#    conditions.merge!({:active => false}) if params[:sf] == 'inactive'
#    conditions.merge!({:approved => false}) if params[:sf] == 'non-approved'
#    # org units
#    conditions.merge!({:location_id => params[:location]}) if params[:location]
#
#    @collection ||= end_of_association_chain.paginate(:page => params[:page], :per_page => 20,
#      :conditions => conditions)
#  end

end
