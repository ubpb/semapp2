class ApplicationController < ActionController::Base

  # TODO: Check me!!
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery # :secret => '9b7f9b9c983a1d298b9fdb40e16e340d'

  include SessionsHelper

  protected

  rescue_from CanCan::AccessDenied do |e|
    flash[:error] = "Zugriff verweigert!"
    redirect_to root_url
    false
  end

end
