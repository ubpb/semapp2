module Provideal
  module PUI
    module Buttons
      module ViewHelpers

        #
        # Renders a link as a JQuery/PUI button
        #
        def pui_link_button(label, *args)
          link_classes = "pui-button ui-state-default ui-corner-all"

          if args.last and args.last.is_a?(Hash)
            options = args.last

            if options.include?(:icon)
              span_classes   = "ui-icon ui-icon-#{options[:icon]}"
              options[:icon] = nil
              link_classes  << " pui-icon"
            end

            if options.include?(:class)
              options[:class] << " #{link_classes}"
            else
              options[:class] = link_classes
            end

            if options.include?(:controller) or options.include?(:action) or options.include?(:id)
              args << {:class => link_classes}
            end

            args.last.merge!(options)
          else
            args << {:class => link_classes}
          end

          if span_classes
            link_to('<span class="'+span_classes+'"></span>'+label, *args)
          else
            link_to(label, *args)
          end
        end


        #
        # Renders a link as a JQuery/PUI icon
        #
        def pui_link_icon(label, icon, *args)
          link_to('<span class="ui-icon ui-icon-'+icon+'">'+label+'</span>', *args)
        end
      end
    end
  end
end