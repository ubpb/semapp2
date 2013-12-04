class Admin::ApplicationController < ApplicationController

  before_filter :require_authenticate
  before_filter :secure_controller

  layout 'admin'

  private

  def secure_controller
    unauthorized! unless current_user and current_user.is_admin?
  end

end
