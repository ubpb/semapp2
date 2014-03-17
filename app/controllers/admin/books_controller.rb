class Admin::BooksController < Admin::ApplicationController

  def edit
    @book = Book.find(params[:id])
    @placeholders = placeholders
  end

  def update
    @book = Book.find(params[:id])
    @placeholders = placeholders

    placeholder_id = BookShelf.clean_ils_account(params[:book][:placeholder])
    if placeholder_id.present? && placeholder = @placeholders.where('book_shelves.ils_account = ?', placeholder_id).first
      @book.placeholder_id = placeholder.id
      @book.state = :in_shelf

      @book.save(validate: false)
      flash[:success] = "Erfolgreich gespeichert"
      redirect_to admin_sem_app_path(@book.sem_app, :anchor => 'new-books')
    else
      flash.now[:error] = "Konnte nicht gespeichert werden. Überprüfen Sie Ihre Eingabe"
      render :edit
    end
  end

  def defer
    @book = Book.find(params[:id])
    unless @book.set_state(:deferred)
      flash[:error] = "Es ist ein Fehler aufgetreten."
    end

    redirect_to admin_sem_app_path(@book.sem_app, :anchor => 'new-books')
  end

  def dedefer
    @book = Book.find(params[:id])
    unless @book.set_state(:ordered)
      flash[:error] = "Es ist ein Fehler aufgetreten."
    end

    redirect_to admin_sem_app_path(@book.sem_app, :anchor => 'new-books')
  end

  def placed_in_shelf
    @book = Book.find(params[:id])
    unless @book.set_state(:in_shelf)
      flash[:error] = "Es ist ein Fehler aufgetreten."
    end

    redirect_to admin_sem_app_path(@book.sem_app, :anchor => 'new-books')
  end

  def removed_from_shelf
    @book = Book.find(params[:id])
    unless @book.destroy
      flash[:error] = "Es ist ein Fehler aufgetreten."
    end

    redirect_to admin_sem_app_path(@book.sem_app, :anchor => 'removed-books')
  end

  def reference
    @book = Book.find(params[:id])
    ref_type = params[:ref_type]

    unless @book.set_state(:in_shelf) and @book.update_attribute(:reference_copy, ref_type)
      flash[:error] = "Es ist ein Fehler aufgetreten."
    end

    redirect_to admin_sem_app_path(@book.sem_app, :anchor => 'new-books')
  end

  def destroy
    @book = Book.find(params[:id])
    unless @book.destroy
      flash[:error] = "Es ist ein Fehler aufgetreten."
    end

    redirect_to admin_sem_app_path(@book.sem_app, :anchor => 'new-books')
  end

private

  def placeholders
    SemApp.includes(:book_shelf).joins(:book_shelf).where(semester_id: Semester.current.id).order('ils_account')
  end

end
