class Admin::SemestersController < Admin::ApplicationController

  before_filter :setup_breadcrumb_for_all_actions

  resource_controller

  create do
    wants.html {redirect_to :action => 'index'}
    flash "Semester erfolgreich erstellt"
    failure do
      flash ""
    end
  end

  update do
    wants.html {redirect_to :action => 'index'}
    flash "Semester erfolgreich aktualisiert"
  end

  destroy do
    flash "Semester erfolgreich gelöscht"
  end

  private

  def setup_breadcrumb_for_all_actions
    pui_append_to_breadcrumb("Semester verwalten", admin_semesters_url)
  end

end
