class SemAppsController < ApplicationController

  before_filter :require_user,       :only => [:create, :edit, :update] # :new is handled in the view to better guide the user
  before_filter :load_sem_app,       :only => [:show,   :edit, :update, :destroy]
  before_filter :check_access,       :only => [:edit,   :update]

  def index
    # filter by semster
    #@semester = Semester.current
    @semester = Semester.find_by_id(params[:semester][:id]) unless params[:semester].blank?
    # filter by location
    @location = Location.find_by_id(params[:location][:id]) unless params[:location].blank?
    # filter by title
    @title    = params[:title]  unless params[:title].blank?
    # filter by tutors
    @tutors   = params[:tutors] unless params[:tutors].blank?

    # build the filter conditions
    conditions = Condition.block do |c|
      c.and "approved", true
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
    # deny read access until the app is approved
    if (not @sem_app.approved?) and not (User.current and User.current.is_admin?)
      flash[:error] = "Zugriff verweigert"
      redirect_to sem_apps_path
      return false
    end
  end

  def new
    @sem_app = SemApp.new
  end

  # TODO: Cherrypick the values for security reasons
  def create
    options = params[:sem_app]
    # Protect some attributes
    options.merge!({
        :approved => false,
        :creator  => User.current
      })
    # Build a new semapp
    @sem_app = SemApp.new(options)
    # Finally create the semapp and add the ownership
    SemApp.transaction do
      if @sem_app.save and @sem_app.add_ownership(User.current)
        flash[:success] = """
          <p>Ihr eSeminarapparat wurde erfolgreich beantragt. Wir prüfen die Angaben und schalten
          den eSeminarappat nach erfolgter Prüfung für Sie frei. Sie sehen den Status unter
          <strong>Meine eSeminarapparate</strong>.</p>
        """
        redirect_to user_path(:anchor => 'apps')
      else
        render :action => :new
      end
    end
  end

  def edit
    # nothing
  end

  # TODO: Cherrypick the values for security reasons
  def update
    options = params[:sem_app]
    # Protect some attributes
    options.merge!({
        :approved  => @sem_app.approved,
        :creator   => @sem_app.creator,
        :semester  => @sem_app.semester,
        :title     => @sem_app.title,
        :course_id => @sem_app.course_id,
        :location  => @sem_app.location
      })

    if @sem_app.update_attributes(params[:sem_app])
      flash[:success] = "Änderungen erfolgreich gespeichert."
      redirect_to sem_app_path(@sem_app)
    else
      render :action => :edit
    end
  end

  private

  def load_sem_app
    @sem_app = SemApp.find_by_id(params[:id])
    unless @sem_app
      flash[:error] = "Der eSeminarapparat den Sie versucht haben aufzurufen existiert nicht."
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

end
