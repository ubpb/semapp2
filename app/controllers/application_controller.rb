require 'ruby-recaptcha'

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  # includes  
  include ReCaptcha::AppHelper

  # include all helpers, all the time
  helper :all

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9b7f9b9c983a1d298b9fdb40e16e340d'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  filter_parameter_logging :password, :password_confirmation

  # Additional helper methods
  #helper_method :User.current_session, :User.current

  private

  #def User.current_session
  #  return @User.current_session if defined?(@User.current_session)
  #  @User.current_session = UserSession.find
  #end

  #def User.current
  #  return @User.current if defined?(@User.current)
  #  @User.current = User.current_session && User.current_session.user
  #end

  def require_user
    unless User.current
      store_location
      flash[:notice] = "Sie müssen sich zunächst anmelden um die Seite aufrufen zu können."
      redirect_to login_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
