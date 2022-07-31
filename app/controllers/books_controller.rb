class BooksController < ApplicationController

  MAX_BOOKS = 40.freeze

  before_action :authenticate!, :load_sem_app
  before_action :check_semester, :only => [:index, :new, :create, :destroy]
  #before_action :check_max_books, only: [:new, :create]

  def index
    @ordered_books  = Book.for_sem_app(@sem_app).ordered.ordered_by('created_at')
    @removed_books  = Book.for_sem_app(@sem_app).removed.ordered_by('created_at')
    @deferred_books = Book.for_sem_app(@sem_app).deferred.ordered_by('created_at')
  end

  def new
    @title_id = params[:title_id]

    if alma_result = get_title_from_alma(@title_id)
      @result = OpenStruct.new({
        title: alma_result["title"] || "n.n.",
        author: alma_result["author"] || "n.n.",
        edition: alma_result["complete_edition"],
        place: alma_result["place_of_publication"],
        publisher: alma_result["publisher_const"],
        year: alma_result["date_of_publication"],
        isbn: alma_result["isbn"]
      })
    end
  end

  def create
    @title_id = params[:title_id]

    if alma_result = AlmaConnector.get_title_from_alma(@title_id)
      @book = Book.new(:sem_app => @sem_app)
      @book.creator    = current_user
      @book.ils_id     = @title_id
      @book.title      = alma_result["title"]  || 'n.n.'
      @book.author     = alma_result["author"] || 'n.n.'
      @book.year       = alma_result["date_of_publication"]
      @book.place      = alma_result["place_of_publication"]
      @book.publisher  = alma_result["publisher_const"]
      @book.isbn       = alma_result["isbn"]
      @book.edition    = alma_result["complete_edition"]

      if @book.save
        flash[:notice] = "Buchauftrag erfolgreich erstellt"
        redirect_to sem_app_books_path(@sem_app)
      else
        flash[:error] = @book.errors[:ils_id].present? ? @book.errors[:ils_id].join : "Es ist ein unbekannter Fehler aufgetreten. Bitte wenden Sie sich an das Informationszentrum der Bibliothek."
        redirect_to new_sem_app_book_path(@sem_app)
      end
    else
      flash[:error] = "Der Buchauftrag konnte nicht erstellt werden. Bitte wenden Sie sich an das Informationszentrum der Bibliothek."
      redirect_to new_sem_app_book_path(@sem_app)
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    @book.update_attribute(:comment, params[:book][:comment])
    redirect_to sem_app_path(@sem_app, :anchor => 'books')
  end

  def destroy
    book = Book.find(params[:id])

    if book.state != Book::States[:in_shelf] or book.placeholder? or book.reference_copy.present?
      book.destroy
    else
      book.set_state(:rejected)
    end

    render body: nil
  end

  private

  def load_sem_app
    @sem_app = SemApp.find(params[:sem_app_id])
    authorize! :edit, @sem_app
  end

  def check_semester
    unless @sem_app.is_from_current_semester? || Semester.current.higher_items.include?(@sem_app.semester) || can?(:manage, :all)
      flash[:error] = "Der Seminarapparat ist nicht aus dem aktuellen oder dem kommenden Semester. Sie können Buchaufträge nur für solche beauftragen bzw. bearbeiten oder löschen."
      redirect_to sem_app_path(@sem_app, :anchor => 'books')
    end
  end

  def check_max_books
    if book_count >= MAX_BOOKS
      flash[:error] = "Sie haben das Maximum von #{MAX_BOOKS} Büchern erreicht. Es können keine weiteren Bücher mehr bestellt werden."
      redirect_to sem_app_books_path(@sem_app)
    end
  end

  def book_count
    Book.for_sem_app(@sem_app).count - Book.for_sem_app(@sem_app).removed.count
  end

end
