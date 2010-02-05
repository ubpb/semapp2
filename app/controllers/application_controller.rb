# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  # include all helpers, all the time
  helper :all

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9b7f9b9c983a1d298b9fdb40e16e340d'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  filter_parameter_logging :password, :password_confirmation

  helper_method :partial_path_for_entry, :partial_path_for_entry_form, :form_url_for_entry

  protected

  def partial_path_for_entry(entry)
    entry.class.name.tableize + '/entry'
  end

  def partial_path_for_entry_form(entry)
    partial_path_for_entry(entry) << "_form"
  end

  def form_url_for_entry(entry)
    if entry.new_record?
      entries_path
    else
      entry_path
    end
  end

end
