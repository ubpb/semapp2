# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def render_sem_app_entry(sem_app_entry)
    partial_name = sem_app_entry.instance_type.underscore
    render 'sem_app_entries/' + partial_name, :entry => sem_app_entry
  end

  def icon_link_to(icon_class, *args, &block)
    link_to('<span class="ui-icon '+icon_class+'"></span>', *args, &block)
  end

  def icon_link_to_remote(icon_class, *args, &block)
    link_to_remote('<span class="ui-icon '+icon_class+'"></span>', *args, &block)
  end

  def button_link_to(label, icon_class, *args, &block)
    link_classes  = "link-button ui-state-default ui-corner-all"
    link_classes += " icon" if icon_class
    span_classes  = "ui-icon #{icon_class}" if icon_class
    
    if args.last.is_a?(Hash)
      link_classes += " " + args.last[:class] if args.last[:class]
      args.last.merge!({:class => link_classes})
    end

    _label  = ''
    _label += '<span class="'+span_classes+'"></span>' if span_classes
    _label += label
    
    link_to(_label, *args, &block)
  end

  def button_link_to_remote(label, icon_class, *args, &block)
    link_classes  = "link-button ui-state-default ui-corner-all"
    link_classes += " icon" if icon_class
    span_classes  = "ui-icon #{icon_class}" if icon_class

    if args.size == 1 and args.last.is_a?(Hash)
      link_classes += " " + args.last[:class] if args.last[:class]
      args << {:class => link_classes}
    else
      link_classes += " " + args.last[:class] if args.last[:class]
      args.last.merge!({:class => link_classes})
    end

    _label  = ''
    _label += '<span class="'+span_classes+'"></span>' if span_classes
    _label += label

    link_to_remote(_label, *args, &block)
  end

end
