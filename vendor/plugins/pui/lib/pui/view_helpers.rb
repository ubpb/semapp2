module PUI
  module ViewHelpers

    

    def label_container(*args, &block)
      options = {:required => false}
      options.merge!(args.last) if args.length > 0 and args.last.is_a?(Hash)
      
      unless block_given?
        raise if args.length < 1
        block_to_partial('/pui/forms/label_container', options) do 
          args[0]
        end
        return nil
      else
        block_to_partial('/pui/forms/label_container', options, &block)
      end
    end
    
    def control_container(*args, &block)
      options = {}
      options.merge!(args.last) if args.length > 0 and args.last.is_a?(Hash)
      
      unless block_given?
        raise if args.length < 1
        block_to_partial('/pui/forms/control_container', options) do
          args[0]
        end
        return nil
      else
        block_to_partial('/pui/forms/control_container', options, &block)
      end
    end
    
    #
    # Renders a link as a JQuery UI icon
    #
    def icon_link_to(icon_class, *args, &block)
      link_to('<span class="ui-icon '+icon_class+'"></span>', *args, &block)
    end
    
  private
    
    def block_to_partial(partial_name, options = {}, &block)
      options.merge!(:body => capture(&block))
      concat(render(:partial => partial_name, :locals => options), &block)
    end
    
  end
end