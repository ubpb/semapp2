class UserSessionsController < ApplicationController
  
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:success] = "Sie haben sich erfolgreich als '#{current_user.login}' angemeldet."
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:success] = "Sie haben sich erfolgreich abgemeldet."
    redirect_to root_url
  end
end