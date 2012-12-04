module Provideal
  module PluginUtils
    class << self
      #
      # Installs your plugins' assets into the host
      # application by linking public/plugins/[your_plugin] to
      # your plugins' public folder.
      #
      # In your plugins' init.rb:
      #
      #   Provideal::PluginUtils.install_assets('your_plugin', 'path to your plugins' public folder')
      #
      # The host application may access the plugins' assets using Rails
      # asset tag helpers together with the provided :plugin option.
      #
      # Example:
      #
      #   <%= javascript_include_tag 'foo.js', :plugin => 'your_plugin' %>
      #
      # This will create a proper link to '/plugins/your_plugin/javascripts/foo.js'.
      #
      def install_assets(plugin_name, source_path)
        # Precheck conditions
        raise "Plugin name required" unless plugin_name
        raise "Source path required" unless source_path
        raise "Source path does't exists" unless File.exists?(source_path)

        # Target path
        target_base_path = "#{::Rails.root}/public/plugins"
        FileUtils.mkdir_p(target_base_path) unless File.exists?(target_base_path)
        target_path = "#{target_base_path}/#{plugin_name}"

        # Only install if the target path does not exists
        unless File.exists?(target_path)
# LocalChange: symlink() function is unimplemented on windows
#          puts "Installing assets for plugin #{plugin_name} from #{source_path} into #{target_path}."
#          File.symlink(source_path, target_path)
          puts "SKIP: Installing assets for plugin #{plugin_name} from #{source_path} into #{target_path}."
# this solution doesn't work due to access problems:         FileUtils.cp(source_path, target_path)
        end
      end

      #
      # Enables Rails extensions
      #
      def enable #:nodoc:
        # enable our overriden asset helper
        require 'provideal_plugin_utils/asset_tag_helper'
        ::ActionView::Helpers::AssetTagHelper.send :include, Provideal::PluginUtils::AssetTagHelper
      end
    end
  end
end

if defined?(Rails) and defined?(ActionController)
  Provideal::PluginUtils.enable
end
