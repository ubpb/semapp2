class Admin::ScanjobsController < Admin::ApplicationController

  def index
    @sem_apps = SemApp.paginate(:all, :include => [:creator, :books], :per_page => 30, :page => params[:page],
        :order => "sem_apps.approved asc, books.state asc, sem_apps.title desc")
  end

end