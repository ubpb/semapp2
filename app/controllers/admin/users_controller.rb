class Admin::UsersController < Admin::ApplicationController

  resource_controller

  before_filter :check_editable, :only => [:edit, :update]
  before_filter :setup_breadcrumb_for_all_actions

  new_action.before do
    pui_append_to_breadcrumb("Ein neuen Benutzer erstellen", new_admin_user_path)
  end

  create do
    wants.html {redirect_to :action => 'index'}
    flash "eSeminarapparat erfolgreich erstellt"
  end

  edit.before do
    pui_append_to_breadcrumb("<strong>#{h(@user)}</strong> bearbeiten", edit_admin_user_path(@user))
  end

  update do
    wants.html {redirect_to :action => 'index'}
    flash "Benutzer erfolgreich aktualisiert"
  end

  destroy do
    flash "Benutzer erfolgreich gelöscht"
  end

  protected

  def collection
    @collection ||= end_of_association_chain.paginate(:page => params[:page], :per_page => 20)
  end

  def check_editable
    unless (object.authid == User::DEFAULT_AUTHID)
      flash[:error] = "Das Konto wird extern verwaltet und kann daher hier nicht bearbeitet werden."
      redirect_to admin_users_path
    end
  end

  def setup_breadcrumb_for_all_actions
    pui_append_to_breadcrumb("Benutzer verwalten", admin_users_path)
  end

end
