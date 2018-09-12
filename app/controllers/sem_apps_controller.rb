class SemAppsController < ApplicationController

  SEM_APP_FILTER_NAME                 = 'sem_app_filter_name_p'.freeze
  SEM_APP_SEMESTER_INDEX_FILTER_NAME  = 'sem_app_semester_index_filter_name_p'.freeze
  SEM_APP_CLONES_FILTER_NAME          = 'sem_app_clones_filter_name_p'.freeze

  before_action :authenticate!, only: [:new, :create, :edit, :update, :generate_access_token, :clones, :filter_clones, :clone]

  def index
    @filter          = SemAppsFilter.get_filter_from_session(session, SEM_APP_FILTER_NAME)
    @filter.approved = true
    @filtered        = @filter.filtered?(except: :approved)

    @sem_apps = @filter.filtered
      .page(params[:page])
      .per_page(10)
  end

  def filter
    SemAppsFilter.set_filter_in_session(session, params[:filter], SEM_APP_FILTER_NAME)
    redirect_to :action => :index
  end

  def semester_index
    @filter             = SemAppsFilter.get_filter_from_session(session, SEM_APP_SEMESTER_INDEX_FILTER_NAME)
    @filter.approved    = true
    @filter.semester_id = Semester.current.id
    @filtered           = @filter.filtered?(except: [:approved, :semester_id])

    @sem_apps = @filter.filtered
      .page(params[:page])
      .per_page(10)
  end

  def filter_semester_index
    SemAppsFilter.set_filter_in_session(session, params[:filter], SEM_APP_SEMESTER_INDEX_FILTER_NAME)
    redirect_to :action => :semester_index
  end

  def show
    load_sem_app or return
    authorize! :read, @sem_app

    # check for access token
    token = params[:token]
    if token.present?
      if @sem_app.access_token == token
        @sem_app.unlock_in_session(session)
      else
        @sem_app.lock_in_session(session)
      end
      redirect_to :action => :show
    end

    @books = Book.for_sem_app(@sem_app).in_shelf.ordered_by
    @media = @sem_app.media
  end

  def new
    @sem_app = SemApp.new
    authorize! :create, @sem_app
    @sem_app.tutors = current_user.name
  end

  def create
    @sem_app = SemApp.new(params.require(:sem_app).permit(
      :semester_id, :title, :course_id, :tutors, :location_id, :shared_secret, :accepts_copyright, :fachzuordnung
    ))
    authorize! :create, @sem_app

    @sem_app.creator = current_user

    # Map Fach to location
    location_id = SemApp2.config.fachzuordnungen.find{|f| f.id == 10}&.location_id
    @sem_app.location = Location.find_by(id: location_id)

    # Finally create the semapp and add the ownership
    if @sem_app.save
      flash[:success] = """
          <p>Ihr Seminarapparat wurde erfolgreich beantragt. Wir prüfen die Angaben und schalten
          den Seminarapparat nach erfolgter Prüfung für Sie frei. Sie sehen den Status unter
          <strong>Meine Seminarapparate</strong>. Bis zur Freischaltung können nur Sie den Seminarapparat
          sehen und bearbeiten.</p>
      """.html_safe

      Notifications.sem_app_created_notification(@sem_app).deliver

      redirect_to user_path(:anchor => 'apps')
    else
      if @sem_app.location.nil?
        @sem_app.errors.add(:fachzuordnung, "Für das Fach konnte kein Standort ermittelt werden. Bitte wenden Sie sich an das Informationszentrum der Bibliothek.")
      end

      render :action => :new
    end
  end

  def edit
    load_sem_app or return
    authorize! :edit, @sem_app

    # Generate access token if no access token exists
    @sem_app.generate_access_token! if @sem_app.access_token.blank?
  end

  def update
    load_sem_app or return
    authorize! :edit, @sem_app

    if @sem_app.update_attributes(params.require(:sem_app).permit(:tutors, :shared_secret))
      flash[:success] = "Änderungen erfolgreich gespeichert."
      redirect_to sem_app_path(@sem_app)
    else
      render :action => :edit
    end
  end

  def unlock
    load_sem_app or return

    shared_secret = params[:shared_secret]

    if (shared_secret == @sem_app.shared_secret) or @sem_app.miless_passwords.map{|p| p.password}.include?(shared_secret)
      @sem_app.unlock_in_session(session)
    else
      flash[:error] = "Die eingegebene Kennung stimmt leider nicht. Texte und Medien können nicht freigeschaltet werden."
    end

    redirect_to sem_app_path(@sem_app, :anchor => 'media')
  end

  def generate_access_token
    load_sem_app or return
    authorize! :edit, @sem_app

    if @sem_app.generate_access_token!
      flash[:success] = 'Es wurde ein neuer Access Token erstellt. Alte Token sind jetzt nicht mehr gültig.'
    else
      flash[:error] = 'Ein neuer Token konnte nicht erstellt werden. Es ist ein Fehler aufgetreten.'
    end

    redirect_to edit_sem_app_path(@sem_app, :anchor => 'token')
  end

  def clones
    load_sem_app or return
    authorize! :edit, @sem_app

    @filter            = SemAppsFilter.get_filter_from_session(session, SEM_APP_CLONES_FILTER_NAME)
    @filter.approved   = true

    @sem_apps = @filter.filtered
     .page(params[:page])
     .per_page(10)

    unless current_user.is_admin?
      @sem_apps = @sem_apps.created_by(current_user)
    end
  end

  def filter_clones
    load_sem_app or return
    authorize! :edit, @sem_app

    SemAppsFilter.set_filter_in_session(session, params[:filter], SEM_APP_CLONES_FILTER_NAME)
    redirect_to :action => :clones
  end

  def clone
    load_sem_app or return
    authorize! :edit, @sem_app

    # Try to find the source sem app we want to clone
    source_sem_app = SemApp.find(params[:source])
    authorize! :edit, source_sem_app

    begin
      cloner = SemAppCloner.new(source_sem_app, @sem_app, clone_books: false, clone_media: true)
      cloner.clone!
      flash[:success] = 'Einträge wurden erfolgreich kopiert.'
    rescue Exception => e
      puts e.backtrace
      flash[:error] = 'Beim kopieren ist leider ein Fehler aufgetrten. Der Vorgang konnte nicht erfolgreich abgeschlossen werden.'
    end

    redirect_to sem_app_path(@sem_app, :anchor => 'media')
  end

private

  def load_sem_app
    begin
      id = params[:id]
      raise "No ID given" unless id

      m  = id.match /^m-(\d+)/
      if m and m[1]
        @sem_app = SemApp.find_by_miless_derivate_id!(m[1])
        flash[:notice] = """
          Sie haben einen alten Seminarapparat aufgerufen und wurden auf das neue System für
          elektronische Seminarapparate weitergeleitet. Bitte aktualisieren die Ihre Links und
          Lesezeichen auf diese neue URL.
        """
        redirect_to sem_app_path(@sem_app, :anchor => 'media') and return
      else
        @sem_app = SemApp.find_by_id!(id)
      end
    rescue
      flash[:error] = "Der Seminarapparat den Sie versucht haben aufzurufen existiert nicht."
      redirect_to sem_apps_path and return
    end

    return true
  end

end
