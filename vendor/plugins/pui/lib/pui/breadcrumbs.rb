module Provideal
  module PUI
    module Breadcrumbs

      module ControllerExtensions

        def pui_set_breadcrumb(breadcrumb_items)
          @_pui_breadcrumb_items = breadcrumb_items
        end

        def pui_append_to_breadcrumb(title, url)
          item = {:title => title, :url => url}

          if @_pui_breadcrumb_items
            @_pui_breadcrumb_items << item
          else
            @_pui_breadcrumb_items = [item]
          end
        end

        #def self.included(subclass)
        #  subclass.class_eval do
        #    self.helper_method :pui_append_to_breadcrumb
        #  end
        #end

      end

      module ViewHelpers

        def pui_breadcrumb(options = {})
          return nil unless @_pui_breadcrumb_items
          return nil if @_pui_breadcrumb_items.empty?

          ul_classes = "pui-breadcrumb ui-corner-all"
          if options.include?(:class)
            options[:class] << " #{ul_classes}"
          else
            options[:class] = ul_classes
          end

          items_string = ""
          if options[:home_url]
            items_string << content_tag(:li, link_to('Home', options[:home_url], :class => 'home'))
          end

          @_pui_breadcrumb_items.each do |item|
            items_string << content_tag(:li, link_to(item[:title], item[:url]))
          end

          content_tag(:ul, items_string, options)
        end

      end
    end
  end
end