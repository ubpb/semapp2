class HomeController < ApplicationController

  protect_from_forgery :only => [:index]

  def index
    # nope
  end

  def sso
    redirect_to root_url
  end

end
