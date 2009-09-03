module Provideal
  module PluginUtils
    class << self
      #
      # Makes the plugins' public assets available to the host
      # application by creating a proper symlink from the host
      # applications' public '_plugin' folder to the plugins'
      # public folder.
      #
      # In your plugins' init.rb:
      #
      #   Provideal::PluginUtils.install_plugin_assets('my_cool_plugin', <path to your plugins' public folder>)
      #
      # In the host application you can then use Rails' asset tag helper
      # functions together with the provided :plugin => '<plugin_name>'
      # option to access the plugins' assets.
      #
      # Example:
      #
      #   <%= javascript_include_tag 'foo', :plugin => 'my_cool_plugin' %>
      #
      # This will create a proper link to '/plugins/my_cool_plugin/javascripts/foo.js'.
      #
      def install_plugin_assets(plugin_name, target_path)
        # Precheck conditions
        raise "Plugin name required" unless plugin_name
        raise "Target path required" unless target_path
        raise "Taget does't exists"  unless File.exists?(target_path)

        # Create the plugins base path inside the hosts public folder
        plugins_public_base_path = "#{RAILS_ROOT}/public/plugins"
        FileUtils.mkdir_p(plugins_public_base_path)

        # The source path
        source_path = "#{plugins_public_base_path}/#{plugin_name}"
        
        # Create the symlink if the source_path is not present
        # This allows for manual overrides
        unless File.exists?(source_path)
          system "ln -s #{target_path} #{source_path}"
        end
      end

      #
      # Enables Rails extensions
      #
      def enable #:nodoc:
        # enable our overriden asset helper
        require 'plugin_utils/asset_tag_helper'
        ::ActionView::Helpers::AssetTagHelper.send :include, Provideal::PluginUtils::AssetTagHelper
      end
    end
  end
end

if defined?(Rails) and defined?(ActionController)
  Provideal::PluginUtils.enable
end
