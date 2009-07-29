class BookOrdersController < ApplicationController

  before_filter :require_user
  before_filter :load_sem_app
  before_filter :check_access
  before_filter :setup_breadcrumb_base

  def index
    @removals  = @sem_app.book_entries(:scheduled_for_removal  => true)
    @additions = @sem_app.book_entries(:scheduled_for_addition => true)
  end

  def new
    @sem_app_book_entry = SemAppBookEntry.new
  end

  def create
    @sem_app_book_entry = SemAppBookEntry.new
    @sem_app_book_entry.scheduled_for_addition = true
    @sem_app_book_entry.signature = params[:sem_app_book_entry][:signature]
    @sem_app_book_entry.title     = params[:sem_app_book_entry][:title]
    @sem_app_book_entry.author    = params[:sem_app_book_entry][:author]
    @sem_app_book_entry.year      = params[:sem_app_book_entry][:year]
    
    sem_app_entry = SemAppEntry.new(:sem_app => @sem_app, :instance => @sem_app_book_entry)

    if (@sem_app_book_entry.save and sem_app_entry.save)
      flash[:notice] = "Buchauftrag erfolgreich erstellt"
      redirect_to sem_app_book_orders_path(@sem_app)
    else
      render :action => :new
    end
  end

  private

  def load_sem_app
    @sem_app = SemApp.find(params[:sem_app_id])
  end

  def setup_breadcrumb_base
    pui_append_to_breadcrumb("eSeminarapparate", sem_apps_path)
    pui_append_to_breadcrumb("eSeminarapparat #{@sem_app.id}", sem_app_path(@sem_app))
    pui_append_to_breadcrumb("Buchaufträge", sem_app_book_orders_path(@sem_app))
  end

  # allow access only for owners and admins
  def check_access
    owner_access = true if User.current.owns_sem_app?(@sem_app)
    admin_access = true if User.current.is_admin?
    unless owner_access or admin_access
      flash[:error] = "Zugriff verweigert"
      redirect_to sem_apps_path
      return false
    end
  end

end