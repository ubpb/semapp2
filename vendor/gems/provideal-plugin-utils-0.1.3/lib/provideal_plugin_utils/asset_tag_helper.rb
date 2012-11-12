module Provideal
  module PluginUtils
    module AssetTagHelper
      
      def self.included(base) #:nodoc:
        base.class_eval do
          [
            :stylesheet_link_tag,
            :javascript_include_tag,
            :image_path,
            :image_tag
          ].each do |m|
            alias_method_chain m, :plugin_support
          end
        end
      end

      def stylesheet_link_tag_with_plugin_support(*sources)
        stylesheet_link_tag_without_plugin_support(*Provideal::PluginUtils::AssetTagHelper.pluginify_sources("stylesheets", *sources))
      end

      def javascript_include_tag_with_plugin_support(*sources)
        javascript_include_tag_without_plugin_support(*Provideal::PluginUtils::AssetTagHelper.pluginify_sources("javascripts", *sources))
      end

      def image_path_with_plugin_support(source, options = {})
        options.stringify_keys!
        pluginified_source = Provideal::PluginUtils::AssetTagHelper.plugin_asset_path(options["plugin"], "images", source) if options["plugin"]
        image_path_without_plugin_support(pluginified_source)
      end

      def image_tag_with_plugin_support(source, options = {})
        options.stringify_keys!
        if options["plugin"]
          pluginified_source = Provideal::PluginUtils::AssetTagHelper.plugin_asset_path(options["plugin"], "images", source)
          options.delete("plugin")
          image_tag_without_plugin_support(pluginified_source, options)
        else
          image_tag_without_plugin_support(source, options)
        end
      end

      def self.pluginify_sources(type, *sources)
        options = sources.last.is_a?(Hash) ? sources.pop.stringify_keys : { }
        if options["plugin"]
          sources.map! { |s| plugin_asset_path(options["plugin"], type, s) }
          options.delete("plugin")
        end
        sources << options
      end

      def self.plugin_asset_path(plugin_name, type, asset)
        "/plugins/#{plugin_name}/#{type}/#{asset}"
      end
    end
  end
end