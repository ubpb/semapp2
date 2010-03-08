class BooksController < ApplicationController

  before_filter :load_sem_app

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
        pager.replace aleph.get_records(t, @page, @per_page)
      end
    end
  end

  def create
    aleph  = get_aleph
    record = aleph.get_record(params[:doc_number])
    base_signature = aleph.get_base_signature(params[:doc_number])

    if record.present? and base_signature.present?
      @book = Book.new(:sem_app => @sem_app)
      @book.creator    = current_user
      @book.ils_id     = record.doc_number
      @book.signature  = base_signature
      @book.title      = record.title
      @book.author     = record.author
      @book.year       = record.year
      @book.place      = record.place
      @book.publisher  = record.publisher
      @book.isbn       = record.isbn
      @book.edition    = record.edition
    
      if @book.save
        flash[:notice] = "Buchauftrag erfolgreich erstellt"
        redirect_to sem_app_books_path(@sem_app)
      else
        flash[:error] = @book.errors.on(:ils_id).present? ? @book.errors.on(:ils_id) : "Es ist ein unbekannter Fehler aufgetreten. Bitte wenden Sie sich an das Informationszentrum der Bibliothek."
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
    book.set_state(:rejected)
    render :nothing => true
  end

  private

  def load_sem_app
    authenticate_user!
    @sem_app = SemApp.find(params[:sem_app_id])
    unauthorized! if cannot? :edit, @sem_app
  end

  def get_aleph
    Aleph::Connector.new
  end

end