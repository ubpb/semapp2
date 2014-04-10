module ApplicationHelper

  # PUI stuff

  def icon(name, options = {})
    image_tag 'pui/icons/' + name, options
    #image_tag('icons/' + name, :plugin => 'pui')
  end

  def navigation_item(options = {:label => 'Item', :url => root_path, :current => false} )
    content_tag(:li, :class => options[:current] ? 'current' : 'none-current') do
      link_to(options[:url]) do
        (options[:icon].present? ? options[:icon] : '') << options[:label]
      end
    end
  end

  def labeled_item(args, &block)
    label   = args[:label] || ''
    content = block_given? ? with_output_buffer(&block) : args[:content] || ''
    content = content.present? ? content : '-'
    # content = h( content ) # TODO: do we need this

    content = content_tag(:div, :class => 'item clearfix') do
      content_tag(:span, label, :class => 'label') << content_tag(:div, content, :class => 'content')
    end

    # block_given? ? with_output_buffer(content) : content
    # block_given? ? concat(content) : content
    # ( block_given? ? concat(content) : content ).html_safe
  end

  def textilize(text)
    text.present? ? RedCloth.new(text).to_html : ""
  end

  def textilize_without_paragraph(text)
    textilized = textilize(text)
    textilized.match(/<p>(.*)<\/p>/m).try(:[], 1) || ""
  end

end
