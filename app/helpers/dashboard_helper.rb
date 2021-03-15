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

  def hf_get_events(meetings)
    if current_user.coaching_type == 'student'
      events_array = []
      if meetings.nil?
        return events_array
      end
      meetings.each do |meeting|
        events = Event.where("id = ? and start_date > ?", meeting.event_id, DateTime.now)
        if !events.empty?
          events_array.push events.first
        end
      end
      return events_array
    elsif current_user.coaching_type == 'dean' and meetings.empty?
        advisor = Advisor.find_by(email: current_user.email)
        if advisor.nil?
          return []
        end
        meetings = Coaching::Meeting.where(advisor_id: advisor.id)
        events_array = []
        meetings.each do |meeting|
          events = Event.where("id = ? and start_date > ?", meeting.event_id, DateTime.now).where.not(user_id: [nil, ''])
          if !events.empty?
            events_array.push events.first
            if events_array.count == 8
              return events_array
            end
          end
        end
        return events_array

    end
  end


end
