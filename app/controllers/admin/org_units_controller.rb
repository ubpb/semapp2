class Admin::OrgUnitsController < Admin::ApplicationController

  before_filter :setup_breadcrumb_for_all_actions

  resource_controller

  new_action.before do
    pui_append_to_breadcrumb("Ein neue Organisationseinheit erstellen", new_admin_org_unit_path)
  end

  create do
    wants.html {redirect_to :action => 'index'}
    flash "Organisationseinheit erfolgreich erstellt"
  end

  edit.before do
    pui_append_to_breadcrumb("<strong>#{h(@org_unit.title)}</strong> bearbeiten", edit_admin_org_unit_path(@org_unit))
  end

  update do
    wants.html {redirect_to :action => 'index'}
    flash "Organisationseinheit erfolgreich aktualisiert"
  end

  destroy do
    flash "Organisationseinheit erfolgreich gelöscht"
  end

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
