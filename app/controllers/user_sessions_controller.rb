class UserSessionsController < ApplicationController
  
  before_filter :require_user, :only => :destroy

  def new
    pui_append_to_breadcrumb("Anmelden", login_url)
    @user_session = UserSession.new
  end

  def create
    pui_append_to_breadcrumb("Anmelden", login_url)

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
    User.current_session.destroy
    flash[:notice] = "Sie haben sich erfolgreich abgemeldet."
    redirect_to root_url
  end
end