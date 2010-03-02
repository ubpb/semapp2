class Admin::Utils::UsersPickerController < Admin::ApplicationController

  # TODO: Remove me
  
#  def users_listing
#    conditions = ["", {}]
#    if (params[:filter] and not params[:filter].blank?)
#      conditions[0] << "login like :filter"
#      conditions[1].merge!({:filter => params[:filter]})
#    end
#
#    users = User.paginate(:page => params[:page], :per_page => 20, :conditions => conditions)
#
#    respond_to do |format|
#      format.js { render :partial => "users_listing", :locals => {:users => users} }
#    end
#  end

end