# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  # disabled for Rails3-upgrade, see http://stackoverflow.com/questions/1179865/why-are-all-rails-helpers-available-to-all-views-all-the-time-is-there-a-way-t
  # Include all helpers, all the time
  # helper :all

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery # :secret => '9b7f9b9c983a1d298b9fdb40e16e340d'

  include SessionsHelper

  protected

  rescue_from Exception do |exception|
    if exception.class == CanCan::AccessDenied
      flash[:error] = "Zugriff verweigert!"
      redirect_to root_url
    else
      logger.fatal("\n\n#{exception.class} (#{exception.message}):\n    " + exception.backtrace.join("\n    ") + "\n\n")
      render 'shared_partials/unhandled_error', :locals => {:exception => exception}
    end
  end

end
