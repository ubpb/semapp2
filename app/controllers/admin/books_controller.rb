class Admin::BooksController < Admin::ApplicationController

  def defer
    @book = Book.find(params[:id])
    unless @book.set_state(:deferred)
      flash[:error] = "Es ist ein Fehler aufgetreten."
    end

    redirect_to admin_sem_app_path(@book.sem_app, :anchor => 'new-books')
  end

  def dedefer
    @book = Book.find(params[:id])
    unless @book.set_state(:new)
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

end
