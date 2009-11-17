class BooksController < ApplicationController

  before_filter :require_user
  before_filter :load_sem_app
  before_filter :check_access

  def index
    @removals  = @sem_app.books(:scheduled_for_removal  => true)
    @additions = @sem_app.books(:scheduled_for_addition => true)
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(:sem_app => @sem_app, :scheduled_for_addition => true)
    @book.signature = params[:book][:signature]
    @book.title     = params[:book][:title]
    @book.author    = params[:book][:author]
    @book.year      = params[:book][:year]
    @book.edition   = params[:book][:edition]
    
    if (@book.save)
      flash[:notice] = "Buchauftrag erfolgreich erstellt"
      redirect_to sem_app_books_path(@sem_app)
    else
      render :action => :new
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.update_attribute(:scheduled_for_removal, true)
    render :nothing => true
  end

  private

  def load_sem_app
    @sem_app = SemApp.find(params[:sem_app_id])
  end

  # allow access only for owners and admins
  def check_access
    unless @sem_app.is_editable?
      flash[:error] = "Zugriff verweigert"
      redirect_to sem_apps_path
      return false
    end
  end

end