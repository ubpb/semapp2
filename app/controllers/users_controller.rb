class UsersController < ApplicationController

  before_filter :require_user
  before_filter :setup_breadcrumb_base

  def show
    @user = current_user
  end

  def edit
    pui_append_to_breadcrumb("Mein Konto bearbeiten", edit_user_path)
    @user = current_user
  end

  def update
    pui_append_to_breadcrumb("Mein Konto bearbeiten", edit_user_path)
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Konto aktualisiert"
      redirect_to user_path
    else
      render :action => :edit
    end
  end

  private

  def setup_breadcrumb_base
    pui_append_to_breadcrumb("Mein Konto", user_path)
  end

end