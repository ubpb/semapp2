class UserSessionsController < ApplicationController
  
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    # Hook in IMT authentication here

    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Sie haben sich erfolgreich als '#{User.current.login}' angemeldet."
      redirect_back_or_default user_url
    else
      render :action => :new
    end
  end

  def destroy
    if User.current
      User.current.logout
      flash[:notice] = "Sie haben sich erfolgreich abgemeldet."
    end
    redirect_to root_url
  end
end