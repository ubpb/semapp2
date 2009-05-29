class Admin::OwnershipsController < Admin::ApplicationController

  before_filter :setup_breadcrumb_for_all_actions

  resource_controller
  belongs_to :sem_app

  create do
    wants.html {redirect_to :action => 'index'}
    flash "Besitzer erfolgreich zugeordnet"
  end

  destroy do
    flash "Besitzer erfolgreich entfernt"
  end

  private

  def setup_breadcrumb_for_all_actions
    pui_append_to_breadcrumb("eSeminarapparate verwalten", admin_sem_apps_url)
  end

end
