module Provideal
  module PUI
    module Panels
      module ViewHelpers

        def pui_panel(options = {}, &block)
          raise "Block required" unless block_given?

          div_classes = "pui-panel"
          if options.include?(:class)
            options[:class] << " #{div_classes}"
          else
            options[:class] = div_classes
          end

          if options.include?(:panel_style)
            options[:class] << " pui-style-#{options[:panel_style]}"
            options.delete(:panel_style)
          else
            options[:class] << " pui-style-default"
          end

          if options.include?(:rounded) and options[:rounded] == true
            options[:class] << " ui-corner-all"
            options.delete(:rounded)
          end

          concat(content_tag(:div, capture(&block), options))
        end
      
      end
    end
  end
end