require 'provideal_plugin_utils'

require 'pui/common'

module PUI
  class << self
      
    def enable #:nodoc:
      ::ActionView::Base.send :include, PUI::Common::ViewHelpers
    end

  end
end


if defined?(Rails) and defined?(ActionController) and defined?(ActionView)
  # Install assets from this plugin
  Provideal::PluginUtils.install_assets('pui', File.expand_path(File.join(File.dirname(__FILE__), '..', 'public')))
  # Finally enable the plugin
  PUI.enable
end