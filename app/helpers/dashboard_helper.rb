module DashboardHelper

  def default_widget_view widget
    # decide on the default div to be visible
    has_type = widget.widget_type
    has_widget = has_type && !widget.widget.nil?
    if widget.invalid? || !has_widget
      return 'widget-config'
    elsif has_type && has_widget
      return 'widget-show'
    elsif has_type
      return 'widget-index'
    else
      return 'widget-config'
    end
  end

  def hf_badge(text, no_of_docs)
    badge = content_tag :span, no_of_docs, class: 'badge badge-warning'
    text = raw "#{text} #{badge}" if no_of_docs
    return text

  end


end
