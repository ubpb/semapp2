class SessionsController < ApplicationController

  def new
  end

  def create
    if user = authenticate(params[:session])
      session[:user_id]          = user.id
      session[:original_user_id] = nil
      redirect_to root_url, notice: 'Sie wurden erfolgreich angemeldet.'
    else
      render "new"
    end
  end

  def destroy
    session[:user_id]          = nil
    session[:original_user_id] = nil
    redirect_to root_url, notice: 'Sie wurden erfolgreich abgemeldet.'
  end

  #
  # Allow admins to switch to another user account
  #
  def switch
    authorize!(:manage, :all)
    user = User.find_by(login: params[:login].upcase)
    if user
      session[:original_user_id] = session[:user_id]
      session[:user_id]          = user.id
      redirect_to root_url, notice: "Sie sind nun der Nutzer mit dem Login #{user.login}."
    else
      redirect_to root_url, notice: "Der Nutzer existiert nicht im System."
    end
  end

  def switch_back
    if session[:user_id] && session[:original_user_id]
      session[:user_id]          = session[:original_user_id]
      session[:original_user_id] = nil
      redirect_to root_url, notice: "Ihre ursprüngliches Login wurde wiederhergestellt."
    else
      redirect_to root_url, notice: "Ihre ursprüngliches Login konnte nicht wiederhergestellt werden."
    end
  end

  protected

    def authenticate(attributes)
      User.authenticate(attributes)
    rescue Exception => e
      puts e.message
      puts e.backtrace
      flash.now[:error] = e.message
      nil
    end

end
