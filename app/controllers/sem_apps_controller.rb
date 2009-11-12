class SemAppsController < ApplicationController

  before_filter :require_user,       :only => [:create, :edit, :update] # :new is handled in the view to better guide the user
  before_filter :load_sem_app,       :only => [:show, :edit, :update, :destroy]
  before_filter :check_access,       :only => [:edit, :update]
  before_filter :check_admin_access, :only => [:destroy]

  def index
    # filter by semster
    @semester = Semester.find_by_id(params[:semester][:id]) unless params[:semester].blank?
    # filter by location
    @location = Location.find_by_id(params[:location][:id]) unless params[:location].blank?
    # filter by title
    @title = params[:title] unless params[:title].blank?
    # filter by tutors
    @tutors = params[:tutors] unless params[:tutors].blank?

    # build the filter conditions
    conditions = Condition.block do |c|
      c.and "approved", true
      c.and "active", true
      c.and "semester_id",    @semester.id if @semester
      c.and "location_id",    @location.id if @location
      c.and "title", "like",  @title.index('%')  ? @title  : "%#{@title}%"  if @title
      c.and "tutors", "like", @tutors.index('%') ? @tutors : "%#{@tutors}%" if @tutors
    end

    # marker that we use some user filter
    @filtered          = true if @semester or @location or @title or @tutors
    @advanced_filtered = true if @location or @title or @tutors

    # find sem apps
    @count    = SemApp.count(:conditions => conditions)
    @sem_apps = SemApp.paginate(
      :page       => params[:page],
      :per_page   => 10,
      :conditions => conditions,
      :order      => 'title, semester_id DESC')
  end

  def show
    # allow access to inactive or unapproved apps only for owners and admins
    owner_access = true if User.current and User.current.owns_sem_app?(@sem_app)
    admin_access = true if User.current and User.current.is_admin?
    if (not @sem_app.active? or not @sem_app.approved?) and not owner_access and not admin_access
      flash[:error] = "Zugriff verweigert"
      redirect_to sem_apps_path
      return false
    end
  end

  def new
    @sem_app = SemApp.new
  end

  def create
    options = params[:sem_app]
    # Protect some attributes
    options.merge!({
        :active   => false,
        :approved => false,
        :creator  => User.current
      })
    # Build a new semapp
    @sem_app = SemApp.new(options)
    # Finally create the semapp and add the ownership
    SemApp.transaction do
      if @sem_app.save and @sem_app.add_ownership(User.current)
        unless User.current.is_admin?
          flash[:notice] = "Ihr eSeminarapparat wurde erfolgreich beantragt. Wir prüfen die Angaben und schalten
        den eSeminarappat nach erfolgter Prüfung frei. Sie sehen den Status unter <strong>Meine eSeminarapparate</strong>."
        else
          flash[:notice] = "eSeminarapparat angelegt."
        end
        redirect_to user_path(:anchor => 'apps')
      else
        render :action => :new
      end
    end
  end

  def edit
    # nothing
  end

  def update
    options = params[:sem_app]
    # Protect some attributes
    options.merge!({
        :active    => @sem_app.active,
        :approved  => @sem_app.approved,
        :creator   => @sem_app.creator,
        :semester  => @sem_app.semester,
        :title     => @sem_app.title,
        :course_id => @sem_app.course_id,
        :location  => @sem_app.location
      })

    if @sem_app.update_attributes(params[:sem_app])
      flash[:notice] = "Änderungen erfolgreich gespeichert."
      redirect_back_or_default user_path(:anchor => 'apps')
    else
      render :action => :edit
    end
  end

  def destroy
    if @sem_app.destroy
      flash[:notice] = "eSeminarapparat erfolgreich gelöscht."
      redirect_to sem_apps_path
    else
      flash[:error] = "eSeminarapparat konnte nicht gelöscht werden. Unbekannter Fehler."
      redirect_to sem_app_path(@sem_app)
    end
  end

  private

  def load_sem_app
    @sem_app = SemApp.find_by_id(params[:id])
    unless @sem_app
      flash[:error] = "Dieser eSeminarapparat existiert nicht"
      redirect_to sem_apps_path
      return false
    end
  end

  def check_access
    unless @sem_app.is_editable?
      flash[:error] = "Zugriff verweigert"
      redirect_to sem_apps_path
      return false
    end
  end

  def check_admin_access
    unless User.current.is_admin?
      flash[:error] = "Zugriff verweigert"
      redirect_to sem_apps_path
      return false
    end
  end

end
