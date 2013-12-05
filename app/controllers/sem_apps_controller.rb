class SemAppsController < ApplicationController

  SEM_APP_FILTER_NAME                 = 'sem_app_filter_name'.freeze
  SEM_APP_SEMESTER_INDEX_FILTER_NAME  = 'sem_app_semester_index_filter_name'.freeze
  SEM_APP_CLONES_FILTER_NAME          = 'sem_app_clones_filter_name'.freeze

  before_filter :load_sem_app, :only => [:show, :edit, :update, :unlock, :transit, :clones, :filter_clones, :clone, :clear, :show_books, :show_media, :generate_access_token]

  before_filter :require_authenticate, only: [:new]

  def index
    @filter = session[SEM_APP_FILTER_NAME] || SemAppsFilter.new
    @filter.approved = true

    @sem_apps = @filter.filtered
      .page(params[:page])
      .per_page(10)
      .order("sem_apps.semester_id asc, sem_apps.title asc")
  end

  def filter
    filter = params[:filter].present? ? SemAppsFilter.new(params[:filter]) : SemAppsFilter.new()
    session[SEM_APP_FILTER_NAME] = filter
    redirect_to :action => :index
  end

  def semester_index
    @filter = session[SEM_APP_SEMESTER_INDEX_FILTER_NAME] || SemAppsFilter.new
    @filter.approved = true
    @filter.semester =  Semester.current.id
    @sem_apps = @filter.filtered
      .page(params[:page])
      .per_page(10)
      .order("sem_apps.semester_id asc, sem_apps.title asc")
  end

  def filter_semester_index
    filter = params[:filter].present? ? SemAppsFilter.new(params[:filter]) : SemAppsFilter.new()
    session[SEM_APP_SEMESTER_INDEX_FILTER_NAME] = filter
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
  end

  def show_books
    unauthorized! if cannot? :read, @sem_app

    load_books

    respond_to do |format|
      format.js { render :partial => 'books_tab', :layout => false }
    end
  end

  def show_media
    unauthorized! if cannot? :read, @sem_app

    load_media

    respond_to do |format|
      format.js { render :partial => 'media_tab', :layout => false }
    end
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
    unauthorized! if @sem_app.semester.id != SemApp2::TRANSIT_SOURCE_SEMESTER_ID

    clone = nil
    begin
      clone = @sem_app.transit
      if clone
        flash[:success] = """
          <p>Ihr Seminarapparat wurde erfolgreich in neue Semester übernommen. Wir prüfen die Angaben und schalten
          den Seminarapparat nach erfolgter Prüfung für Sie frei. Sie sehen den Status unter
          <strong>Meine Seminarapparate</strong>. Bis zur Freischaltung können nur Sie den Seminarapparat
          sehen und bearbeiten.</p>
        """.html_safe
      else
        flash[:error] = 'Bei dem Vorgang ist ein Fehler aufgetreten. Bitte wenden Sie sich an den Support.'
      end
    end

    redirect_to (clone.present?) ? sem_app_path(clone) : sem_apps_path
  end

  def clones
    unauthorized! if cannot? :edit, @sem_app

    @filter = session[SEM_APP_CLONES_FILTER_NAME] || SemAppsFilter.new
    @sem_apps = @filter.filtered
      .page(params[:page])
      .per_page(10)
      .where(:approved => true)
      .order("sem_apps.semester_id asc, sem_apps.title asc")
  end

  def filter_clones
    unauthorized! if cannot? :edit, @sem_app

    filter = params[:filter].present? ? SemAppsFilter.new(params[:filter]) : SemAppsFilter.new()
    session[SEM_APP_CLONES_FILTER_NAME] = filter
    redirect_to clones_sem_app_path(@sem_app)
  end

  def clone
    unauthorized! if cannot? :edit, @sem_app

    # Try to find the source sem app we want to clone
    source_sem_app = SemApp.find(params[:source])

    # Check the password in the case the user has no edit rights
    # on the source sem app (needed for old Miless sem apps)
    if cannot? :edit, source_sem_app
      password = params[:password]
      unless password.present?
        flash[:error] = "Bitte geben Sie das Passwort des Seminarapparates ein das sie damals (im alten System) bei der Beantragung gesetzt haben."
        redirect_to :action => :clones
        return false
      end

      unless source_sem_app.miless_passwords.map{|p| p.password}.include?(password)
        flash[:error] = "Das Passwort ist falsch. Der Seminarapparat konnte nicht geklont werden."
        redirect_to :action => :clones
        return false
      end
    end

    begin
      @sem_app.import_entries(source_sem_app)
      flash[:success] = 'Einträge wurden erfolgreich kopiert.'
    rescue Exception => e
      puts e.backtrace
      flash[:error] = 'Beim kopieren ist leider ein Fehler aufgetrten. Der Vorgang konnte nicht erfolgreich abgeschlossen werden.'
    end
    redirect_to sem_app_path(@sem_app, :anchor => 'media')
  end

  def clear
    unauthorized! if cannot? :edit, @sem_app

    if @sem_app.entries.destroy_all
      flash[:success] = 'Alle Einträge wurden gelöscht.'
    else
      flash[:error] = 'Einträge konnten nicht gelöscht werden. Es ist ein Fehler aufgetreten.'
    end

    redirect_to sem_app_path(@sem_app, :anchor => 'media')
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

  def load_books
    @books = Book.for_sem_app(@sem_app).in_shelf.ordered_by
  end

  def load_media
=begin
    headline_entries = HeadlineEntry.find(:all, :conditions => { :sem_app_id => @sem_app.id }, :include => [:file_attachments, :scanjob], :order => 'position asc')
    text_entries = TextEntry.find(:all, :conditions => { :sem_app_id => @sem_app.id }, :include => [:file_attachments, :scanjob], :order => 'position asc')
    monograph_entries = MonographEntry.find(:all, :conditions => { :sem_app_id => @sem_app.id }, :include => [:file_attachments, :scanjob], :order => 'position asc')
    article_entries = ArticleEntry.find(:all, :conditions => { :sem_app_id => @sem_app.id }, :include => [:file_attachments, :scanjob], :order => 'position asc')
    collected_article_entries = CollectedArticleEntry.find(:all, :conditions => { :sem_app_id => @sem_app.id }, :include => [:file_attachments, :scanjob], :order => 'position asc')
    miless_file_entries = MilessFileEntry.find(:all, :conditions => { :sem_app_id => @sem_app.id }, :include => [:file_attachments, :scanjob], :order => 'position asc')
    @media = [headline_entries, text_entries, monograph_entries, article_entries, collected_article_entries, miless_file_entries].flatten.compact
    @media = @media.sort do |x,y|
      return -1 if x.position.blank?
      return -1 if y.position.blank?
      x.position <=> y.position
    end
=end
    @media = [HeadlineEntry, TextEntry, MonographEntry, ArticleEntry,
                CollectedArticleEntry, MilessFileEntry].map do |entry|
      entry.where(sem_app_id: @sem_app.id)
           .includes(:file_attachments, :scanjob)
           .order('position ASC')
           .load
    end

    @media = @media.flatten.compact.sort do |x,y|
      return -1 if x.position.blank?
      return -1 if y.position.blank?
      x.position <=> y.position
    end
  end

end
