module Provideal
  module PUI
    module Common
      module ViewHelpers

        def pui_defaults_tag
          code  = ''
          code << javascript_include_tag('jquery/jquery-1.3.2.min.js', :plugin => 'pui') << "\n"
          code << javascript_include_tag('jquery/ui/jquery-ui-1.7.2.custom.min.js', :plugin => 'pui') << "\n"
          code << javascript_include_tag('jquery/jquery-cookie.js', :plugin => 'pui') << "\n"
          code << '<script type="text/javascript">jQuery.noConflict();</script>' << "\n"
          code << stylesheet_link_tag('jquery/ui/themes/smoothness/jquery-ui-1.7.2.custom.css', :media => "all", :plugin => 'pui') << "\n"
          code << javascript_include_tag('jquery-tools-min.js', :plugin => 'pui') << "\n"

          code << javascript_include_tag('default.js', :plugin => 'pui') << "\n"
          code << stylesheet_link_tag('main.css', :plugin => 'pui') << "\n"
        end

      end
    end
  end
end