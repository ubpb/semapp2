class UsersController < ApplicationController

  before_filter :require_user,      :only => [:show, :edit, :update, :password, :change_password]
  before_filter :load_current_user, :only => [:show, :edit, :update, :password, :change_password]
  before_filter :check_editable,    :only => [       :edit, :update, :password, :change_password]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    # For now we don't have a seperate approval process.
    # So approve and activate the user.
    # This may change in the future
    @user.approved = true
    @user.active   = true

    if @user.save
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
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "Sie haben Ihr Konto erfolgreich aktualisiert"
      redirect_to user_path
    else
      render :action => :edit
    end
  end

  def password
  end

  def change_password
    if @user.update_attributes(params[:user])
      flash[:notice] = "Sie haben Ihr Passwort erfolgreich aktualisiert"
      redirect_to user_path
    else
      render :action => :password
    end
  end

  private

  def load_current_user
    @user = User.current
    raise "No user logged in. That was not expected" unless @user
  end

  def check_editable
    unless (@user.authid == User::DEFAULT_AUTHID)
      flash[:error] = "Ihr Konto wird extern verwaltet und kann daher hier nicht bearbeitet werden."
      redirect_to user_path
    end
  end

end