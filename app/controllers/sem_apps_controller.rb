class SemAppsController < ApplicationController

  before_filter :authenticate_user!, :only => [:create, :edit, :update] # :new is handled in the view to better guide the user
  before_filter :load_sem_app, :only => [:show, :edit, :update, :destroy, :unlock]
  before_filter :check_lecturer, :only => [:create]
  before_filter :check_access, :only => [:edit, :update]

  def index
    # filter by semster
    @semester = Semester.find_by_id(params[:semester][:id]) if params[:semester].present? and params[:semester][:id].present?
    # filter by location
    @location = Location.find_by_id(params[:location][:id]) if params[:location].present? and params[:location][:id].present?
    # filter by title
    @title    = params[:title]  if params[:title].present?
    # filter by tutors
    @tutors   = params[:tutors] if params[:tutors].present?

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
    if (not @sem_app.approved?) and not (current_user and current_user.is_admin?)
      flash[:error] = "Zugriff verweigert"
      redirect_to sem_apps_path
      return false
    end
  end

  def new
    @sem_app = SemApp.new
  end

  def create
    @sem_app = SemApp.new(params[:sem_app])
    @sem_app.creator = current_user

    # Finally create the semapp and add the ownership
    SemApp.transaction do
      if @sem_app.save and @sem_app.add_ownership(current_user)
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

  def unlock
    shared_secret = params[:shared_secret]
    if shared_secret == @sem_app.shared_secret
      @sem_app.unlock_in_session(session)
    else
      flash[:error] = "Die eingegebene Kennung stimmt leider nicht. Texte und Medien können nicht freigeschaltet werden."
    end

    redirect_to sem_app_path(@sem_app, :anchor => 'media')
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
    unless @sem_app.is_editable_for?(current_user)
      flash[:error] = "Zugriff verweigert"
      redirect_to sem_apps_path
      return false
    end
  end

  def check_lecturer
    unless current_user.has_authority?(Authority::LECTURER_ROLE)
      flash[:error] = "Zugriff verweigert"
      redirect_to sem_apps_path
      return false
    end
  end

end
