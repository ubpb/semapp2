module PUI
  module Common
    module ViewHelpers

      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::AssetTagHelper
      include ActionView::Helpers::JavaScriptHelper

      def include_pui(options = {})
        options = {
          :jquery             => true,
          :jquery_tools       => true,
          :jquery_form        => true,
          :jquery_no_conflict => true,
          :use_cdn            => false,
          :use_pui_css        => true,
          :use_reset_css      => true,
          :use_960gs_css      => true,
          :use_default_css    => true,
          :use_formtastic     => true,
          :cache_file_suffix  => "pui"
        }.merge(options)

        options[:jquery] = (options[:jquery] == true) ? "1.3.2" : (options[:jquery].is_a? String) ? options[:jquery] : false

        javascripts = []
        javascript_code = []
        stylesheets = []
        # enable jquery core
        if options[:jquery]
          if options[:use_cdn]
            javascripts << "http://ajax.googleapis.com/ajax/libs/jquery/#{options[:jquery]}/jquery.min.js"
          else
            javascripts << "jquery-#{options[:jquery]}.min.js"
          end

          if options[:jquery_no_conflict]
            javascript_code << javascript_tag('jQuery.noConflict();')
          end
        end
        # enable jquery tools
        if options[:jquery_tools]
          if options[:use_cdn]
            javascripts << 'http://cdn.jquerytools.org/1.1.2/jquery.tools.min.js'
          else
            javascripts << 'jquery-tools-1.1.2.min.js'
          end
        end
        # enable jquery form plugin
        if options[:jquery_form]
          javascripts << 'jquery-form-2.33.js'
        end
        # enable pui.js
        javascripts << 'pui.js'
        # enable reset css
        if options[:use_reset_css]
          stylesheets << "reset.css"
        end
        # enable 960gs css
        if options[:use_960gs_css]
          stylesheets << "960.css"
        end
        # enable pui css
        if options[:use_pui_css]
          stylesheets << "pui.css"
        end
        # enable content default css
        if options[:use_default_css]
          stylesheets << "default.css"
        end
        # enable formtastic
        if options[:use_formtastic]
          stylesheets << "formtastic.css"
          stylesheets << "formtastic-changes.css"
        end

        includes = []
        # Include all stylesheets (and cache them as well)
        includes << stylesheet_link_tag(*stylesheets << {:media => 'all', :plugin => 'pui', :cache => "generated-#{options[:cache_file_suffix]}"})
        # Include all javascripts (and cache them as well)
        includes << javascript_include_tag(*javascripts << {:plugin => 'pui', :cache => "generated-#{options[:cache_file_suffix]}"})
        # Write out javascript code
        includes << javascript_code.join("\n")

        # return the code
        return includes.join("\n")
      end

      def navigation_item(options = {:label => 'Item', :url => root_path, :current => false} )
        content_tag(:li, :class => options[:current] ? 'current' : 'none-current') do
          link_to(options[:url]) do
            (options[:icon].present? ? options[:icon] : '') << options[:label]
          end
        end
      end

      def icon(name)
        image_tag('icons/' + name, :plugin => 'pui')
      end

      def labeled_item(args, &block)
        label   = args[:label] || ''
        content = block_given? ? capture(&block) : args[:content] || ''
        content = content.present? ? content : '-'

        content = content_tag(:div, :class => 'item clearfix') do
          content_tag(:span, label, :class => 'label') << content_tag(:div, content, :class => 'content')
        end

        block_given? ? concat(content) : content
      end

    end
  end
end