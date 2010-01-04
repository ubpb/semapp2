class Admin::SemAppsController < Admin::ApplicationController

#  resource_controller
#
#  new_action.before do
#  end
#
#  create do
#    wants.html {redirect_to :action => 'index'}
#    flash "eSeminarapparat erfolgreich erstellt"
#  end
#
#  edit.before do
#  end
#
#  update do
#    wants.html {redirect_to :action => 'index'}
#    flash "eSeminarapparat erfolgreich aktualisiert"
#  end
#
#  destroy do
#    flash "eSeminarapparat erfolgreich gelöscht"
#  end
#
#  private
#
#  def collection
#    conditions = {}
#    # state filters
#    conditions.merge!({:active => false}) if params[:sf] == 'inactive'
#    conditions.merge!({:approved => false}) if params[:sf] == 'non-approved'
#    # org units
#    conditions.merge!({:location_id => params[:location]}) if params[:location]
#
#    @collection ||= end_of_association_chain.paginate(:page => params[:page], :per_page => 20,
#      :conditions => conditions)
#  end

end
