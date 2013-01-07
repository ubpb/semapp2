# encoding: utf-8

class Admin::SemAppsController < Admin::ApplicationController

  SEM_APP_FILTER_NAME = 'admin_sem_app_filter_name'.freeze

  def index
    @filter = session[SEM_APP_FILTER_NAME] || SemAppsFilter.new
    if @filter
      @sem_apps = @filter.filtered.paginate(
        # :all, 
        :per_page => 10, 
        :page => params[:page],
        :include => [:creator, :books, :semester],  
        :order => "semesters.position asc, sem_apps.title asc")
    else
      @sem_apps = SemApp.paginate(
        # :all, 
        :per_page => 10, 
        :page => params[:page],
        :include => [:creator, :books, :semester], 
        :order => "semesters.position asc, sem_apps.title asc")
    end
  end

  def filter
    filter = SemAppsFilter.new(params[:filter])
    session[SEM_APP_FILTER_NAME] = filter
    redirect_to :action => :index
  end

  def show
    @sem_app        = SemApp.find_by_id(params[:id])
    (flash[:error] = "Dieser Apparat existiert nicht"; redirect_to admin_sem_apps_path) unless @sem_app.present?

    @ordered_books  = Book.for_sem_app(@sem_app).ordered.ordered_by('signature asc')
    @removed_books  = Book.for_sem_app(@sem_app).removed.ordered_by('signature asc')
    @deferred_books = Book.for_sem_app(@sem_app).deferred.ordered_by('signature asc')


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
      flash[:success] = "Der Seminarapparat wurde erfolgreich erstellt"
      redirect_to :action => :index
    else
      @sem_app.build_book_shelf unless @sem_app.book_shelf.present?
      render :action => :new
    end
  end

  def edit
    @sem_app = SemApp.find(params[:id])
    @sem_app.build_book_shelf unless @sem_app.book_shelf.present?
    @sem_app.build_book_shelf_ref unless @sem_app.book_shelf_ref.present?
  end

  def update
    @sem_app = SemApp.find(params[:id])
    
    was_approved = @sem_app.approved

    if @sem_app.update_attributes(params[:sem_app])
      if (@sem_app.approved and not was_approved and @sem_app.creator.present? and @sem_app.creator.email.present?)
        Notifications.sem_app_activated_notification(@sem_app).deliver
      end
      flash[:success] = "Die Daten wurden erfolgreich gespeichert"
      redirect_to :action => :show
    else
      render :action => :edit
    end
  end

  def set_creator
    @sem_app = SemApp.find(params[:id])
    
    login = params[:login].upcase
    user  = User.find_by_login(login)
    
    if user
      if @sem_app.update_attribute(:creator, user)
        flash[:success] = ActionController::Base.helpers.sanitize "Besitzer erfolgreich gesetzt. #{login} kann den Seminarapparat <i>#{@sem_app.title}</i> nun bearbeiten."
      else
        flash[:error] = "Fehler: Der Benutzer konnte nicht als Besitzer eingetragen werden."
      end
    else
      u = User.new(:login => login)
      if u.save(false) and @sem_app.update_attribute(:creator, u)
        flash[:success] = ActionController::Base.helpers.sanitize "Der Benutzer '#{login}' existierte nicht, wurde aber angelegt. Name und E-Mail sind erst verfügbar wenn der Nutzer sich das erste mal anmeldet. #{login} kann den Seminarapparat <i>#{@sem_app.title}</i> nun bearbeiten."
      else
        flash[:error] = "Es ist ein unbekannter Fehler aufgetreten!"
      end
    end

    redirect_to admin_sem_app_path(@sem_app, :anchor => 'users')
  end

  def destroy
    @sem_app = SemApp.find(params[:id])
    @sem_app.destroy
    flash[:success] = "Seminarpparat '#{@sem_app.title}' gelöscht."
    redirect_to :action => :index
  end

end
