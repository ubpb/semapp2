class Admin::ApplicationController < ApplicationController

  before_filter :authenticate_user!
  before_filter :check_for_admin_role

  layout 'admin'

  def redirect_to_default
    redirect_to admin_sem_apps_path
  end

  private

  def check_for_admin_role
    unless current_user.is_admin?
      flash[:error] = "Zugriff verweigert"
      redirect_to root_url
    end
  end

end