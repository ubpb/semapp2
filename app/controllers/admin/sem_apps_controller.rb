class Admin::SemAppsController < Admin::ApplicationController

  before_filter :setup_breadcrumb_for_all_actions
  
  def index
    @sem_apps = SemApp.find(:all, :order => 'created_at DESC')
  end

  def new
    @sem_app = SemApp.new
    setup_breadcrumb_for_new_and_create
  end

  def create
    @sem_app = SemApp.new(params[:sem_app])
    setup_breadcrumb_for_new_and_create

    if (@sem_app.save)
      flash[:success] = "eSeminarapparate erfolgreich erstellt"
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @sem_app = SemApp.find(params[:id])
    setup_breadcrumb_for_edit_and_update(@sem_app)
  end

  def update
    @sem_app = SemApp.find(params[:id])
    setup_breadcrumb_for_edit_and_update(@sem_app)

    @sem_app.update_attributes(params[:sem_app])
      
    if @sem_app.save
      flash[:success] = "eSeminarapparat erfolgreich aktualisiert"
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    sem_app = SemApp.find(params[:id])
    if sem_app and sem_app.destroy
      flash[:success] = "eSeminarapparat '#{sem_app.title}' erfolgreich gelöscht"
      redirect_to :action => 'index'
    else
      flash[:error] = "eSeminarapparat konnte nicht gelöscht werden"
      redirect_to :action => 'index'
    end
  end

  private

  def setup_breadcrumb_for_all_actions
    pui_append_to_breadcrumb("eSeminarapparate verwalten", admin_sem_apps_url)
  end

  def setup_breadcrumb_for_new_and_create
    pui_append_to_breadcrumb("Neuen eSeminarapparat anlegen", new_admin_sem_app_url)
  end

  def setup_breadcrumb_for_edit_and_update(sem_app)
    pui_append_to_breadcrumb("eSeminarapparat bearbeiten", edit_admin_sem_app_url(sem_app))
  end

end
