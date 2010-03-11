# encoding: utf-8

class UsersController < ApplicationController

  before_filter :authenticate_user!

  def show
    @user = current_user
    @my_sem_apps = SemApp.find(:all, :conditions => {:creator_id => @user.id}, :order => 'title')
    @ownerships  = @user.ownerships.map {|o| o.sem_app}
  end

end