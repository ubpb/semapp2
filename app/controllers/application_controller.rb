class ApplicationController < ActionController::Base

  protect_from_forgery

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authenticate!
    unless current_user
      redirect_to(login_url, alert: "Anmeldung erforderlich.") and return
    end
  end

  rescue_from CanCan::AccessDenied do |e|
    flash[:error] = "Zugriff verweigert!"
    redirect_to(root_url)
  end

end
