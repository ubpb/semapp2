# encoding: utf-8

class Admin::ApplicationController < ApplicationController

  # TODO: TMP-DEVISE-DEACTIVATION - reactivate this
  # before_filter :secure_controller

  layout 'admin'

  private

  def secure_controller
    authenticate_user!
    unauthorized! unless current_user and current_user.is_admin?
  end

end