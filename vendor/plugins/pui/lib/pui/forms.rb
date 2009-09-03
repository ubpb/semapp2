module Provideal
  module PUI
    module Forms
      module ViewHelpers

        def pui_form_field_info_message(options = {}, &block)
          raise "Block required" unless block_given?

          div_classes = "pui-info-message"
          if options.include?(:class)
            options[:class] << " #{div_classes}"
          else
            options[:class] = div_classes
          end

          concat(content_tag(:div, capture(&block), options))
        end

      end
    end
  end
end