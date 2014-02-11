class Admin::ApplicationController < ApplicationController

  before_filter :require_authenticate
  before_filter :secure_controller

  layout 'admin'

  private

  def secure_controller
    authorize! :manage, :all
  end

end
