# encoding: utf-8

class Admin::ApplicationController < ApplicationController

  before_filter :secure_controller

  layout 'admin'

  private

  def secure_controller
    authenticate_user!
    unauthorized! unless current_user or current_user.is_admin?
  end

end