class BooksController < ApplicationController

  before_filter :authenticate_user!
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
    aleph  = get_aleph
    record = aleph.get_record(params[:doc_number])
    item   = aleph.get_item(params[:doc_number])

    if record.present? and item.present?
      @book = Book.new(:sem_app => @sem_app, :scheduled_for_addition => true)
      @book.ils_id     = record.doc_number
      @book.signature  = item.call_no_1
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

  def destroy
    book = Book.find(params[:id])
    book.update_attribute(:scheduled_for_removal, true)
    render :nothing => true
  end

  def lookup
    @title     = params[:title]
    @author    = params[:author]
    @isbn      = params[:isbn]
    @signature = params[:signature]

    search_terms  = []
    search_terms << "pti=#{@title}"     if @title.present?
    search_terms << "wpe=#{@author}"    if @author.present?
    search_terms << "ibn=#{@isbn}"      if @isbn.present?
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

  private

  def load_sem_app
    @sem_app = SemApp.find(params[:sem_app_id])
  end

  # allow access only for owners and admins
  def check_access
    unless @sem_app.is_editable_for?(current_user)
      flash[:error] = "Zugriff verweigert"
      redirect_to sem_apps_path
      return false
    end
  end

  # TODO: Move this to a proper location
  def get_aleph
    Aleph::Connector.new(:base_url => 'http://ubaleph.uni-paderborn.de/X', :library => 'pad50', :search_base => 'pbaus')
  end

end