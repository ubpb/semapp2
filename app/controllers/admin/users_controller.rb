class Admin::UsersController < Admin::ApplicationController

  resource_controller

  before_filter :check_editable, :only => [:edit, :update]
  before_filter :check_deleteable, :only => [:destroy]  

  new_action.before do
  end

  create do
    wants.html {redirect_to :action => 'index'}
    flash "Benutzer erfolgreich erstellt"
  end

  edit.before do
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
    conditions = ["", {}]
    if (params[:filter] and not params[:filter].blank?)
      conditions[0] << "login like :filter"
      conditions[1].merge!({:filter => params[:filter]})
    end

    @collection ||= end_of_association_chain.paginate(:page => params[:page], :per_page => 20, :conditions => conditions)
  end

  def check_editable
    unless (object.authid == User::DEFAULT_AUTHID)
      flash[:error] = "Das Konto wird extern verwaltet und kann daher hier nicht bearbeitet werden."
      redirect_to admin_users_path
    end
  end

  def check_deleteable
    if (object == current_user)
      flash[:error] = "Sie können Ihr eigenes Konto nicht löschen."
      redirect_to admin_users_path
    end
  end

end
