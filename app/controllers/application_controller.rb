class ApplicationController < ActionController::Base

  # TODO: Check me!!
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery # :secret => '9b7f9b9c983a1d298b9fdb40e16e340d'

  include SessionsHelper

  protected

  rescue_from Exception do |exception|
    if Rails.env.production?
      if exception.class == CanCan::AccessDenied
        flash[:error] = "Zugriff verweigert!"
        redirect_to root_url
      else
        logger.fatal("\n\n#{exception.class} (#{exception.message}):\n    " + exception.backtrace.join("\n    ") + "\n\n")
        render 'shared_partials/unhandled_error', :locals => {:exception => exception}
      end
    else
      raise exception
    end
  end

end
