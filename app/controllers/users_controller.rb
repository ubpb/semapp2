# encoding: utf-8

class UsersController < ApplicationController

  before_filter :require_authenticate

  def show
    @user = current_user

    @my_sem_apps = SemApp.paginate(
      # :all,
      :per_page => 10,
      :page => params[:page],
      :conditions => {:creator_id => @user.id},
      :include => :semester,
      :order => "semesters.position asc, sem_apps.title asc")

    @ownerships  = @user.ownerships.map {|o| o.sem_app}
  end

end