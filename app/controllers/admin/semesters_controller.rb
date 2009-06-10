class Admin::SemestersController < Admin::ApplicationController

  before_filter :setup_breadcrumb_for_all_actions

  resource_controller

  new_action.before do
    pui_append_to_breadcrumb("Ein neues Semester erstellen", new_admin_semester_path)
  end

  create do
    wants.html {redirect_to :action => 'index'}
    flash "Semester erfolgreich erstellt"
  end

  edit.before do
    pui_append_to_breadcrumb("<strong>#{h(@semester.title)}</strong> bearbeiten", edit_admin_semester_path(@semester))
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
    pui_append_to_breadcrumb("Semester verwalten", admin_semesters_path)
  end

end
