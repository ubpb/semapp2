class SemAppsController < ApplicationController

  SEM_APP_FILTER_NAME = 'sem_app_filter_name'.freeze

  before_filter :authenticate_user!, :only => [:create, :edit, :update] # :new is handled in the view to better guide the user
  before_filter :load_sem_app, :only => [:show, :edit, :update, :unlock]
  before_filter :check_lecturer, :only => [:create]
  before_filter :check_access, :only => [:edit, :update]

  def index
    @filter = session[SEM_APP_FILTER_NAME] || SemAppsFilter.new
    if @filter
      @sem_apps = @filter.scope.paginate(:all, :conditions => {:approved => true}, :per_page => 30, :page => params[:page],
        :order => "sem_apps.created_at")
    else
      @sem_apps = SemApp.paginate(:all, :conditions => {:approved => true}, :per_page => 30, :page => params[:page],
        :order => "sem_apps.created_at")
    end
  end

  def filter
    filter = SemAppsFilter.new(params[:filter])
    session[SEM_APP_FILTER_NAME] = filter
    redirect_to :action => :index
  end

  def show
    # deny read access until the app has been approved
    if (not @sem_app.approved?) and not (current_user and current_user.is_admin?)
      flash[:error] = "Zugriff verweigert"
      redirect_to sem_apps_path
      return false
    else
      @books = Book.for_sem_app(@sem_app).in_shelf.ordered_by
      @media = Entry.for_sem_app(@sem_app).ordered_by
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
