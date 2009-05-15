class Admin::ApplicationController < ApplicationController

  before_filter :setup_base_breadcrumb

  private

  def setup_base_breadcrumb
    pui_append_to_breadcrumb("Administration", root_url)
  end

end