class Admin::OwnershipsController < Admin::ApplicationController

  before_filter :setup_breadcrumb_for_all_actions

  resource_controller
  belongs_to :sem_app

  index.before do
    pui_append_to_breadcrumb("<strong>#{h(@sem_app.title)}</strong> bearbeiten", edit_admin_sem_app_path(@sem_app))
  end

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
