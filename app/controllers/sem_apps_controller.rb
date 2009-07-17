class SemAppsController < ApplicationController

  before_filter :require_user, :only => [:create]

  def index
    pui_append_to_breadcrumb("eSeminarapparate", sem_apps_path)

    # filter by semster
    @semester = Semester.find_by_id(params[:semester][:id]) unless params[:semester].blank?
    # filter by location
    @location = Location.find_by_id(params[:location][:id]) unless params[:location].blank?
    # filter by title
    @title = params[:title] unless params[:title].blank?
    @title = "%#{@title}%" if @title and not @title.index('%')
    # filter by tutors
    @tutors = params[:tutors] unless params[:tutors].blank?
    @tutors = "%#{@tutors}%" if @tutors and not @tutors.index('%')

    # build the filter conditions
    conditions = Condition.block do |c|
      c.and "approved", true
      c.and "active", true
      c.and "semester_id", @semester.id if @semester
      c.and "location_id", @location.id if @location
      c.and "title", "like", @title if @title
      c.and "tutors", "like", @tutors if @tutors
    end

    # marker that we use some user filter
    @filtered          = true if @semester or @location or @title or @tutors
    @advanced_filtered = true if @location or @title or @tutors

    # find sem apps
    @count = SemApp.count(:conditions => conditions)
    @sem_apps = SemApp.paginate(
      :page => params[:page],
      :per_page => 10,
      :conditions => conditions,
      :order => 'title, semester_id DESC')
  end

  def show
    @sem_app = SemApp.find_by_id(params[:id])

     # check existance
    unless @sem_app
      flash[:error] = "Dieser eSeminarapparat existiert nicht"
      redirect_to sem_apps_path
      return false
    end

    # allow access to inactive or unapproved apps only for owners and admins
    owner_access = true if current_user and current_user.owns_sem_app?(@sem_app)
    admin_access = true if current_user and current_user.is_admin?
    if (not @sem_app.active? or not @sem_app.approved?) and not owner_access and not admin_access
      flash[:error] = "Zugriff verweigert"
      redirect_to sem_apps_path
      return false
    end

    # Setup breadcrumb
    pui_append_to_breadcrumb("eSeminarapparate", sem_apps_path)
    pui_append_to_breadcrumb("eSeminarapparat #{@sem_app.id}", sem_app_path(@sem_app))
  end

  def new
    @sem_app = SemApp.new
    
    pui_append_to_breadcrumb("Einen neuen eSeminarapparat beantragen", new_sem_app_path)
  end

  def create
    @sem_app = SemApp.new(params[:sem_app])
    if @sem_app.save and @sem_app.add_ownership(current_user)
      flash[:notice] = "Ihr eSeminarapparat wurde erfolgreich beantragt. Wir prüfen die Angaben und schalten
        den eSeminarappat nach erfolgter Prüfung frei. Sie sehen den Status auf Ihrer Konto Seite unter
        <strong>Meine eSeminarapparate</strong>."
      redirect_to user_path(:anchor => 'apps')
    else
      render :action => :new
    end
  end
  
end
