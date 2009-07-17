class Admin::BookOrdersController < Admin::ApplicationController

  before_filter :setup_breadcrumb_for_all_actions

  resource_controller
  belongs_to :sem_app

  update do
    wants.html { redirect_to :action => 'index' }
    flash "Buchauftrag erfolgreich aktualisiert"
  end

  destroy do
    wants.html { redirect_to :action => 'index' }
    flash "Buchauftrag erfolgreich gelöscht"
  end

  private

  def setup_breadcrumb_for_all_actions
    pui_append_to_breadcrumb("eSeminarapparate verwalten", admin_sem_apps_url)
    pui_append_to_breadcrumb("<strong>#{h(parent_object.title)}</strong> bearbeiten", edit_admin_sem_app_path(parent_object))
  end

end