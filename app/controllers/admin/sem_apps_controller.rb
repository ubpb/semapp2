class Admin::SemAppsController < Admin::ApplicationController

  before_filter :setup_breadcrumb_for_all_actions

  resource_controller

  create do
    wants.html {redirect_to :action => 'index'}
    flash "eSeminarapparat erfolgreich erstellt"
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
    pui_append_to_breadcrumb("eSeminarapparate verwalten", admin_sem_apps_url)
  end

end
