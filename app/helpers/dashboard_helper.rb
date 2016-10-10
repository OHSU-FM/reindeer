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
end
