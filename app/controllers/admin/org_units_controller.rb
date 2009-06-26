class Admin::OrgUnitsController < Admin::ApplicationController

  before_filter :setup_breadcrumb_for_all_actions

  resource_controller
  
  private

  def setup_breadcrumb_for_all_actions
    pui_append_to_breadcrumb("Organisationseinheiten verwalten", admin_org_units_path)
  end

end
