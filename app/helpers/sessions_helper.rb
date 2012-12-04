module SessionsHelper

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # TODO: support friendly forwarding
  #       http://ruby.railstutorial.org/chapters/updating-showing-and-deleting-users#sec-friendly_forwarding
  def require_authenticate
    redirect_to login_url, alert: "Anmeldung erforderlich." unless current_user
    current_user.nil?
  end
  alias require_authenticate? require_authenticate

=begin friendly forwarding stuff
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def redirect_back
    redirect_back_or root_url
  end

  def store_location
    session[:return_to] = request.url
  end
=end
end
