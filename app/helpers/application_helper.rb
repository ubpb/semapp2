# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # includes
  include ReCaptcha::ViewHelper

  def render_sem_app_entry(entry)
    partial_name = entry.instance.class.name.underscore
    render 'sem_app_entries/' + partial_name, :entry => entry
  end

  def render_sem_app_entry_form(entry, form_type = 'new')
    partial_name = entry.instance.class.name.underscore.concat('_form_').concat(form_type)
    render 'sem_app_entries/' + partial_name, :entry => entry
  end

end
