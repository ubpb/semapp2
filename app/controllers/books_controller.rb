class BooksController < ApplicationController

  MAX_BOOKS = 40.freeze

  before_filter :require_authenticate, :load_sem_app
  before_filter :check_current_semester, :only => [:index, :new, :create, :destroy]
  #before_filter :check_max_books, only: [:new, :create]

  def index
    @ordered_books  = Book.for_sem_app(@sem_app).ordered.ordered_by('created_at')
    @removed_books  = Book.for_sem_app(@sem_app).removed.ordered_by('created_at')
    @deferred_books = Book.for_sem_app(@sem_app).deferred.ordered_by('created_at')
  end

  def new
    #@title     = params[:title]
    #@author    = params[:author]
    #@isbn      = params[:isbn]
    @signature = params[:signature]
    @signature = Book.get_base_signature(@signature) if @signature.present?

    search_terms  = []
    #search_terms << "pti=#{@title}"     if @title.present?
    #search_terms << "wpe=#{@author}"    if @author.present?
    #search_terms << "ibn=#{@isbn}"      if @isbn.present?
    search_terms << "psg=#{@signature}" if @signature.present?

    search_term = "(#{search_terms.join(" and ")})"

    aleph = get_aleph
    t     = aleph.find(search_term)
    if t.present?
      @page          = params[:page].present? ? params[:page].to_i : 1
      @per_page      = 10
      @total_results = t[1]

      # Use pagination with will_paginate
      @results = WillPaginate::Collection.create(@page, @per_page, @total_results) do |pager|
        pager.replace(aleph.get_records(t, @page, @per_page))
      end
    end
  end

  def create
    aleph  = get_aleph
    record = aleph.get_record(params[:doc_number])
    signature = aleph.get_signature(params[:doc_number])

    if record.present? and signature.present?
      @book = Book.new(:sem_app => @sem_app)
      @book.creator    = current_user
      @book.ils_id     = record.doc_number
      @book.signature  = signature     || 'n.n'
      @book.title      = record.title  || 'n.n'
      @book.author     = record.author || 'n.n'
      @book.year       = record.year
      @book.place      = record.place
      @book.publisher  = record.publisher
      @book.isbn       = record.isbn
      @book.edition    = record.edition

      if @book.save
        flash[:notice] = "Buchauftrag erfolgreich erstellt"
        redirect_to sem_app_books_path(@sem_app)
      else
        flash[:error] = @book.errors[:ils_id].present? ? @book.errors[:ils_id].join : "Es ist ein unbekannter Fehler aufgetreten. Bitte wenden Sie sich an das Informationszentrum der Bibliothek."
        redirect_to new_sem_app_book_path(@sem_app)
      end
    else
      flash[:error] = "Der Buchauftrag konnte nicht erstellt werden. Ggf. kann das gefundenen Exemplar nicht beauftragt werden (z.B. elektronische Resource). Bitte wenden Sie sich an das Informationszentrum der Bibliothek."
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

    render :nothing => true
  end

  private

  def load_sem_app
    @sem_app = SemApp.find(params[:sem_app_id])
    authorize! :edit, @sem_app
  end

  def check_current_semester
    unless @sem_app.is_from_current_semester?
      flash[:error] = "Der Seminarapparat ist nicht aus dem aktuellen Semester. Sie können Buchaufträge nur für aktuelle Seminarapparate beauftragen bzw. bearbeiten oder löschen."
      redirect_to sem_app_path(@sem_app, :anchor => 'books')
    end
  end

  def check_max_books
    if book_count >= MAX_BOOKS
      flash[:error] = "Sie haben das Maximum von #{MAX_BOOKS} Büchern erreicht. Es können keine weiteren Bücher mehr bestellt werden."
      redirect_to sem_app_books_path(@sem_app)
    end
  end

  def get_aleph
    Aleph::Connector.new
  end

  def book_count
    Book.for_sem_app(@sem_app).count - Book.for_sem_app(@sem_app).removed.count
  end

end
