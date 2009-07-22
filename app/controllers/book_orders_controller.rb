class BookOrdersController < ApplicationController

  before_filter :require_user
  before_filter :check_access
  before_filter :setup_breadcrumb_base
  
  resource_controller
  
  belongs_to :sem_app

  new_action.before do
    pui_append_to_breadcrumb("Neu...", new_sem_app_book_order_path(parent_object))
  end

  create do
    wants.html { redirect_to :action => 'index' }
    flash "Buchauftrag erfolgreich erstellt"
  end

  private

  def setup_breadcrumb_base
    pui_append_to_breadcrumb("eSeminarapparate", sem_apps_path)
    pui_append_to_breadcrumb("eSeminarapparat #{parent_object.id}", sem_app_path(parent_object))
    pui_append_to_breadcrumb("Buchaufträge", sem_app_book_orders_path(parent_object))
  end

  # allow access only for owners and admins
  def check_access
    owner_access = true if User.current.owns_sem_app?(parent_object)
    admin_access = true if User.current.is_admin?
    unless owner_access or admin_access
      flash[:error] = "Zugriff verweigert"
      redirect_to sem_apps_path
      return false
    end
  end

end