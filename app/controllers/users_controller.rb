class UsersController < ApplicationController

  before_filter :require_user
  before_filter :load_current_user
  before_filter :check_editable, :only => [:edit, :update]
  before_filter :setup_breadcrumb_base

  def show    
  end

  def edit
    pui_append_to_breadcrumb("Mein Konto bearbeiten", edit_user_path)
  end

  def update
    pui_append_to_breadcrumb("Mein Konto bearbeiten", edit_user_path)
    if @user.update_attributes(params[:user])
      flash[:notice] = "Sie haben Ihr Konto erfolgreich aktualisiert"
      redirect_to user_path
    else
      render :action => :edit
    end
  end

  private

  def load_current_user
    @user = current_user
  end

  def check_editable
    unless (@user.authid == User::DEFAULT_AUTHID)
      flash[:error] = "Ihr Konto wird extern verwaltet und kann daher hier nicht bearbeitet werden."
      redirect_to user_path
    end
  end

  def setup_breadcrumb_base
    pui_append_to_breadcrumb("Mein Konto", user_path)
  end

end