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
    @query = params[:query]

    if @query.present? && result = CatalogConnector.search_print_title(@query)
      @results = result["hits"].map { |hit|
        record = hit["record"]
        next unless record

        place, publisher = record["publication_notices"].first&.split(" : ")

        OpenStruct.new({
          title:       record["title"].presence&.truncate(250)  || "n.n.",
          author:      record["creators"].map{|c|c["name"]}.join("; ").presence || "n.n.",
          edition:     record["edition"],
          place:       place,
          publisher:   publisher,
          year:        record["year_of_publication"],
          isbn:        record["additional_identifiers"].select{|i| i["type"] == "isbn"}.map{|i| i["value"]}.join("; "),
          call_number: record["call_numbers"].join("; "),
          ils_id:      record["id"]
        })
      }.compact
    end
  end

  def create
    @ils_id = params[:ils_id]

    if @ils_id.present? && alma_result = AlmaConnector.get_title(@ils_id)
      @book = Book.new(:sem_app => @sem_app)
      @book.creator    = current_user
      @book.ils_id     = @ils_id
      @book.title      = alma_result["title"].presence&.truncate(250)  || 'n.n.'
      @book.author     = alma_result["author"].presence || 'n.n.'
      @book.year       = alma_result["date_of_publication"]
      @book.place      = alma_result["place_of_publication"]
      @book.publisher  = alma_result["publisher_const"]
      @book.isbn       = alma_result["isbn"]
      @book.edition    = alma_result["complete_edition"]
      @book.signature  = alma_result["call_number"]

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

    comment = params.dig(:book, :comment)
    ebook_reference = params.dig(:book, :ebook_reference)

    @book.update(
      comment: comment,
      ebook_reference: ebook_reference
    )

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
