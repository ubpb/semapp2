class Admin::BooksController < Admin::ApplicationController

  before_action :load_book


  def edit
    @placeholders = placeholders
  end

  def update
    @placeholders = placeholders

    placeholder_id = BookShelf.clean_ils_account(params[:book][:placeholder])
    placeholder    = @placeholders.where('book_shelves.ils_account = ?', placeholder_id).first

    if placeholder_id.present? && placeholder.present?
      @book.placeholder_id = placeholder.id
      @book.state = :in_shelf

      @book.save(validate: false)
      flash[:success] = "Erfolgreich gespeichert"
      redirect_to_new_books
    else
      flash.now[:error] = "Konnte nicht gespeichert werden. Überprüfen Sie Ihre Eingabe"
      render :edit
    end
  end

  def defer
    unless @book.set_state(:deferred)
      set_common_flash_error
    end

    redirect_to_new_books
  end

  def dedefer
    unless @book.set_state(:ordered)
      set_common_flash_error
    end

    redirect_to_new_books
  end

  def placed_in_shelf
    unless @book.set_state(:in_shelf)
      set_common_flash_error
    end

    redirect_to_new_books
  end

  def removed_from_shelf
    unless @book.destroy
      set_common_flash_error
    end

    redirect_to_removed_books
  end

  def reference
    unless @book.set_state(:in_shelf) and @book.update_attribute(:reference_copy, params[:ref_type])
      set_common_flash_error
    end

    redirect_to_new_books
  end

  def destroy
    unless @book.destroy
      flash[:error] = "Es ist ein Fehler aufgetreten."
    end

    redirect_to_new_books
  end

private

  def load_book
    @book = Book.find(params[:id])
  end

  def placeholders
    SemApp.includes(:book_shelf).joins(:book_shelf).where(semester_id: Semester.current.id).order('ils_account')
  end

  def set_common_flash_error
    flash[:error] = "Es ist ein Fehler aufgetreten."
  end

  def redirect_to_new_books
    redirect_to admin_sem_app_path(@book.sem_app, :anchor => 'new-books')
  end

  def redirect_to_removed_books
    redirect_to admin_sem_app_path(@book.sem_app, :anchor => 'removed-books')
  end

end
