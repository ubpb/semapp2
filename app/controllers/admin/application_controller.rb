class Admin::ApplicationController < ApplicationController

  before_filter :setup_admin_breadcrumb

  private

  def setup_admin_breadcrumb
    pui_append_to_breadcrumb("Administration", root_url)
  end

end