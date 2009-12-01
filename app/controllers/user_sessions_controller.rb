class UserSessionsController < ApplicationController
  
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    # Hook in IMT authentication here

    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Sie haben sich erfolgreich als '#{current_user.login}' angemeldet."
      redirect_to root_url
    else
      render :action => :new
    end
  end

  def destroy
    if current_user
      current_user_session.destroy if current_user_session
      flash[:notice] = "Sie haben sich erfolgreich abgemeldet."
    end
    redirect_to root_url
  end
end