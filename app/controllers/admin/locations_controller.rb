class Admin::LocationsController < Admin::ApplicationController

  resource_controller

  new_action.before do
  end

  create do
    wants.html {redirect_to :action => 'index'}
    flash "Standort erfolgreich erstellt"
  end

  edit.before do
  end

  update do
    wants.html {redirect_to :action => 'index'}
    flash "Standort erfolgreich aktualisiert"
  end

  destroy do
    flash "Standort erfolgreich gelöscht"
  end

  def reorder
    locations = params[:locations]
    if locations
      Location.transaction do
        locations.each_index do |i|
          id = params[:locations][i]
          if (id and !id.empty?)
            location = Location.find_by_id!(id)
            location.position = i
            location.save!
          end
        end
      end
    end
    render :nothing => true
  end
  
  private

  def collection
    @collection ||= end_of_association_chain.find(:all, :order => 'position')
  end

end
