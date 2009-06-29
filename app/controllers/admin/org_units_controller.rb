class Admin::OrgUnitsController < Admin::ApplicationController

  before_filter :setup_breadcrumb_for_all_actions

  resource_controller

  def reorder
    org_units = params[:org_units]
    if org_units
      OrgUnit.transaction do
        org_units.each_index do |i|
          id = params[:org_units][i]
          if (id and !id.empty?)
            org_unit = OrgUnit.find_by_id!(id)
            org_unit.position = i
            org_unit.save!
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

  def setup_breadcrumb_for_all_actions
    pui_append_to_breadcrumb("Organisationseinheiten verwalten", admin_org_units_path)
  end

end
