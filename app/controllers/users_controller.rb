class UsersController < ApplicationController

  before_filter :require_user, :only => [:show, :edit, :update]
  before_filter :load_current_user, :only => [:show, :edit, :update]
  before_filter :check_editable, :only => [:edit, :update]  
  before_filter :setup_breadcrumb_base, :only => [:show, :edit, :update]

  def new
    pui_append_to_breadcrumb("Mein Konto erstellen", new_user_path)
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    # For now we don't have a seperate approval process.
    # So approve and activate the user.
    # This may change in the future
    @user.approved = true
    @user.active   = true

    if (validate_recap(params, @user.errors) and @user.save)
      flash[:notice] = "Ihr Benutzerkonto wurde erfolgreich eingerichtet und sie wurden bereits angemeldet."
      UserSession.create(@user, false)
      redirect_to user_path
    else
      render :action => :new
    end
  end

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
    pui_append_to_breadcrumb("Meine Seite", user_path)
  end

end