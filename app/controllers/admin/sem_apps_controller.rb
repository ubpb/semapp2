class Admin::SemAppsController < Admin::ApplicationController

  before_filter :setup_breadcrumb_for_all_actions

  resource_controller

  new_action.before do
    pui_append_to_breadcrumb("Ein neuen eSeminarapparat erstellen", new_admin_sem_app_path)
  end

  create do
    wants.html {redirect_to :action => 'index'}
    flash "eSeminarapparat erfolgreich erstellt"
  end

  edit.before do
    pui_append_to_breadcrumb("<strong>#{h(@sem_app.title)}</strong> bearbeiten", edit_admin_sem_app_path(@sem_app))
  end

  update do
    wants.html {redirect_to :action => 'index'}
    flash "eSeminarapparat erfolgreich aktualisiert"
  end

  destroy do
    flash "eSeminarapparat erfolgreich gelöscht"
  end

  private

  def setup_breadcrumb_for_all_actions
    pui_append_to_breadcrumb("eSeminarapparate verwalten", admin_sem_apps_path)
  end

end
