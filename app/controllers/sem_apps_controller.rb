class SemAppsController < ApplicationController

  SEM_APP_FILTER_NAME = 'sem_app_filter_name'.freeze

  before_filter :load_sem_app, :only => [:show, :edit, :update, :unlock]
  
  def index
    @filter = session[SEM_APP_FILTER_NAME] || SemAppsFilter.new
    @sem_apps = @filter.scope.paginate(
      :all,
      :conditions => {:approved => true},
      :per_page => 10,
      :page => params[:page],
      :order => "sem_apps.semester_id asc, sem_apps.title asc")
  end

  def filter
    filter = params[:filter].present? ? SemAppsFilter.new(params[:filter]) : SemAppsFilter.new()
    session[SEM_APP_FILTER_NAME] = filter
    redirect_to :action => :index
  end

  def show
    unauthorized! if cannot? :read, @sem_app

    @books = Book.for_sem_app(@sem_app).in_shelf.ordered_by
    @media = Entry.for_sem_app(@sem_app).ordered_by
  end

  def new
    authenticate_user! unless current_user
    @sem_app = SemApp.new
    unauthorized! if cannot? :create, @sem_app
    @sem_app.tutors = current_user.name
  end

  def create
    @sem_app = SemApp.new(params[:sem_app])
    unauthorized! if cannot? :create, @sem_app

    @sem_app.creator = current_user

    # Finally create the semapp and add the ownership
    if @sem_app.save and @sem_app.add_ownership(current_user)
      flash[:success] = """
          <p>Ihr Seminarapparat wurde erfolgreich beantragt. Wir prüfen die Angaben und schalten
          den Seminarapparat nach erfolgter Prüfung für Sie frei. Sie sehen den Status unter
          <strong>Meine Seminarapparate</strong>. Bis zur Freischaltung können nur Sie den Seminarapparat
          sehen und bearbeiten.</p>
      """
      redirect_to user_path(:anchor => 'apps')
    else
      render :action => :new
    end
  end

  def edit
    unauthorized! if cannot? :edit, @sem_app
  end

  def update
    unauthorized! if cannot? :edit, @sem_app

    # Cherrypick the values for security reasons
    options = {}
    options[:tutors]        = params[:sem_app][:tutors]
    options[:shared_secret] = params[:sem_app][:shared_secret]
    
    if @sem_app.update_attributes(options)
      flash[:success] = "Änderungen erfolgreich gespeichert."
      redirect_to sem_app_path(@sem_app)
    else
      render :action => :edit
    end
  end

  def unlock
    shared_secret = params[:shared_secret]
    if (shared_secret == @sem_app.shared_secret) or @sem_app.miless_passwords.map{|p| p.password}.include?(shared_secret)
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
      flash[:error] = "Der Seminarapparat den Sie versucht haben aufzurufen existiert nicht."
      redirect_to sem_apps_path
      return false
    end
  end

end
