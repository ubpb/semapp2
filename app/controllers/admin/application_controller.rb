class Admin::ApplicationController < ApplicationController

  before_filter :require_user
  before_filter :check_for_admin_role

  private

  def check_for_admin_role
    unless User.current.is_admin?
      flash[:error] = "Zugriff verweigert"
      redirect_to root_url
    end
  end

end