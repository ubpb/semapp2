# encoding: utf-8

class UsersController < ApplicationController

  before_filter :require_authenticate

  def show
    @user = current_user

    @my_sem_apps = SemApp
      .page(params[:page])
      .per_page(10)
      .where(:creator_id => @user.id)
      .includes(:semester)
      .order("semesters.position asc, sem_apps.title asc")

    @ownerships  = @user.ownerships.map {|o| o.sem_app}
  end

end
