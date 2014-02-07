class SemAppsController < ApplicationController

  SEM_APP_FILTER_NAME                 = 'sem_app_filter_name_p'.freeze
  SEM_APP_SEMESTER_INDEX_FILTER_NAME  = 'sem_app_semester_index_filter_name_p'.freeze
  SEM_APP_CLONES_FILTER_NAME          = 'sem_app_clones_filter_name_p'.freeze

  before_filter :load_sem_app, :only => [:show, :edit, :update, :unlock, :transit, :clones, :filter_clones, :clone, :clear, :show_books, :show_media, :generate_access_token]

  before_filter :require_authenticate, only: [:new]

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
    unauthorized! if cannot? :read, @sem_app

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
    unauthorized! if cannot? :create, @sem_app
    @sem_app.tutors = current_user.name
  end

  def create
    @sem_app = SemApp.new(params[:sem_app])
    unauthorized! if cannot? :create, @sem_app

    @sem_app.creator = current_user

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
      render :action => :new
    end
  end

  def edit
    unauthorized! if cannot? :edit, @sem_app

    # Generate access token if no access token exists
    @sem_app.generate_access_token! if @sem_app.access_token.blank?
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

  def transit
    unauthorized! if cannot?(:edit, @sem_app)
    unauthorized! if @sem_app.semester.id != ApplicationSettings.instance.transit_source_semester.id

    if clone = @sem_app.transit
      flash[:success] = """
        <p>Ihr Seminarapparat wurde erfolgreich in das neue Semester übernommen. Wir prüfen die Angaben und schalten
        den Seminarapparat nach erfolgter Prüfung für Sie frei. Sie sehen den Status unter
        <strong>Meine Seminarapparate</strong>. Bis zur Freischaltung können nur Sie den Seminarapparat
        sehen und bearbeiten.</p>
      """.html_safe
      redirect_to sem_app_path(clone)
    else
      flash[:error] = 'Bei dem Vorgang ist ein Fehler aufgetreten. Bitte wenden Sie sich an den Support.'
      redirect_to sem_apps_path
    end
  end

  def generate_access_token
    unauthorized! if cannot? :edit, @sem_app

    if @sem_app.generate_access_token!
      flash[:success] = 'Es wurde ein neuer Access Token erstellt. Alte Token sind jetzt nicht mehr gültig.'
    else
      flash[:error] = 'Ein neuer Token konnte nicht erstellt werden. Es ist ein Fehler aufgetreten.'
    end

    redirect_to edit_sem_app_path(@sem_app, :anchor => 'token')
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
        redirect_to sem_app_path(@sem_app, :anchor => 'media')
        return false
      else
        @sem_app = SemApp.find_by_id!(id)
      end
    rescue
      flash[:error] = "Der Seminarapparat den Sie versucht haben aufzurufen existiert nicht."
      redirect_to sem_apps_path
      return false
    end
  end

end
