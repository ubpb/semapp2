class Admin::ApplicationController < ApplicationController

  before_action :authenticate!
  before_action :secure_controller

  layout 'admin'

  private

  def secure_controller
    authorize! :manage, :all
  end

end
