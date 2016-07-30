module Assignment::UserAssignmentsHelper

  def hf_selected_owner_status? ur, status
    ur.owner_status == status
  end

  def hf_set_status_button_class ur, status
    ur.owner_status == status ? "primary" : "default"
  end

  def hf_ag_owner_or_higher? usr, obj
    case obj
    when Assignment::AssignmentGroup
      usr == obj.owner || usr.admin_or_higher?
    when Assignment::UserResponse
      usr == obj.ag_owner || usr.admin_or_higher?
    else
      false
    end
  end

  # returns html badge span w # of ur w/o owner status
  def hf_ur_owner_badge usr, current_user
    return unless hf_ag_owner_or_higher? current_user, @assignment_group
    if usr.unstatused_user_responses_count > 0
      " <span class=\"badge\">#{usr.unstatused_user_responses_count}</span>"
    end
  end

  # for single ur, false when user is owner & ur.owner_status == nil
  # for mult urs, false when user is owner & any ur.owner_status == nil
  def hf_show_ur_status? resp, user
    case resp
    when ActiveRecord::Relation
      !(resp.collect{|ur| ur.owner_status}.any?(&:blank?) && resp.first.ag_owner == user)
    when Assignment::UserResponse
      !(resp.owner_status.nil? && resp.ag_owner == user)
    else
      false
    end
  end

  # returns bootstrap label type depending on resp status & possible statuses
  def hf_label_color ur, sym
    if ur.respond_to? sym
      stat_h = ur.user_assignment.status_hash(ur.user_assignment.status_lime_question)
      return "" if stat_h.empty?

      status_possibilities = stat_h.length
      status_index = stat_h.invert[ur[sym]][1].to_i - 1

      case status_possibilities
      when 2
        possibilities = ["danger", "success"]
      when 3
        possibilities = ["warning", "info", "success"]
      when 4
        possibilities = ["warning", "info", "primary", "success"]
      else
        possibilities = ["danger", "warning", "info", "primary", "success"]
      end
      possibilities[status_index * (status_possibilities / possibilities.length)]
    else
      raise NoMethodError
    end
  end

  def hf_category_status_label responses
    label_kls, label_text = category_status_calculator(responses)
    return "<span class=\"label label-#{label_kls}\">#{label_text}</span>"
  end

  def hf_category_status_button responses, category
    btn_kls, btn_text = category_status_calculator(responses)
    btn_kls = "default" unless hf_show_ur_status? responses, current_user
    return """
           <button type=\"button\" class=\"btn btn-#{btn_kls} dropdown-toggle\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"false\">
             #{category.titleize}<span class=\"caret\"></span>
           </button>
           """
  end

  def hf_ua_title_prettify ua
    ua.group_and_title.join(": ")
  end

  def hf_user_assignment_button_text locals
    if !locals.has_key?(:btn_text)
      "All Sessions <span class='caret'></span>"
    else
      "<span class='caret'></span> #{locals[:btn_text]}"
    end
  end

  # returns { "month": ["assignment type", ua] }
  def hf_user_assignment_cycle_hash obj
    usr = obj.methods.include?(:user) ? obj.user : User.find(obj)

    hash = Hash.new
    usr.user_assignments.each.map {|ua|
      k, v = ua.survey_assignment.title.chomp.split(":", 2)
      !hash.key?(k) ? hash[k] = [[v, ua]] : hash[k] << [v, ua]
    }
    hash.sort.to_h
  end

  private

    # takes list of resps, finds completion %, returns value on a 3-point scale
    def category_status_calculator responses
      possibilities = [
        [ "warning", "Needs Work" ],
        [ "info", "On Track" ],
        [ "success", "Excelling" ]
      ]
      total, actual = 0, 0
      responses.each do |ur|
        stat_h = ur.user_assignment.status_hash(ur.user_assignment.status_lime_question)
        unless stat_h.empty?
          total += stat_h.length
          actual += stat_h.invert[ur.status][1].to_i - 1
        end
      end
      total += 1 unless total > 0
      kls, text = possibilities[(3 * (actual/total.to_f)).floor]
    end
end
