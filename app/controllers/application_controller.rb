class ApplicationController < ActionController::Base

  protect_from_forgery

  include SessionsHelper

  protected

  rescue_from CanCan::AccessDenied do |e|
    flash[:error] = "Zugriff verweigert!"
    redirect_to root_url
    false
  end

end
