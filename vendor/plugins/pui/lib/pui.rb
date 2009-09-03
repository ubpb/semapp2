module Provideal
  module PUI
    class << self
      def enable
        # Common stuff
        require 'pui/common'
        ::ActionView::Base.send :include, Provideal::PUI::Common::ViewHelpers

        # Buttons
        require 'pui/buttons'
        ::ActionView::Base.send :include, Provideal::PUI::Buttons::ViewHelpers

        # Panels
        require 'pui/panels'
        ::ActionView::Base.send :include, Provideal::PUI::Panels::ViewHelpers

        # Breadbrumbs
        require 'pui/breadcrumbs'
        ::ActionController::Base.send :include, Provideal::PUI::Breadcrumbs::ControllerExtensions
        ::ActionView::Base.send :include, Provideal::PUI::Breadcrumbs::ViewHelpers

        # Forms
        require 'pui/forms'
        ::ActionView::Base.send :include, Provideal::PUI::Forms::ViewHelpers
        fix_field_with_error
        ActionView::Base.default_form_builder = Provideal::PUI::FormBuilder
      end

      def fix_field_with_error
        ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
          if html_tag =~ /^<label.*>.*$/
            '<span class="pui-field-with-errors">'+html_tag+'</span>'
          else
            html_tag
          end
        end
      end
    end

    class FormBuilder < ActionView::Helpers::FormBuilder

      def text_field(method, options = {})
        # Get the original implementation
        code = super(method, options)
        # extract error message
        if error_message = error_message_for_object(method, options)
          code << error_message
        end
        # extract info message
        if info_message = info_message_for_object(options)
          code << info_message
        end
        # return
        code
      end

      def password_field(method, options = {})
        # Get the original implementation
        code = super(method, options)
        # extract error message
        if error_message = error_message_for_object(method, options)
          code << error_message
        end
        # extract info message
        if info_message = info_message_for_object(options)
          code << info_message
        end
        # return
        code
      end

      def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
        # Get the original implementation
        code = super(method, collection, value_method, text_method, options, html_options)
        # extract error message
        method_name = method.to_s.gsub(/_id/, '')
        if error_message = error_message_for_object(method_name, options)
          code << error_message
        end
        # extract info message
        if info_message = info_message_for_object(options)
          code << info_message
        end
        # return
        code
      end

      private

      def info_message_for_object(options = {})
        if options[:info_message]
          return "<div class=\"pui-info-message\">#{options[:info_message]}</div>"
        end
      end

      def error_message_for_object(method, options = {})
        # Get a reference to the model object
        object = @template.instance_variable_get("@#{@object_name}")

        # Make sure we have an object and we're not told to hide errors for this label
        unless object.nil? || options[:hide_errors]
          # Check if there are any errors for this field in the model
          errors = object.errors.on(method.to_sym)
          if errors
            return "<div class=\"pui-error-message\">#{errors.is_a?(Array) ? errors.first : errors}</div>"
          end
        end
      end
    end
  end
end

if defined?(Rails) and defined?(ActionController) and defined?(ActionView)
  Provideal::PluginUtils.install_plugin_assets('pui', File.expand_path(File.join(File.dirname(__FILE__), '..', 'public')))

  Provideal::PUI.enable
end