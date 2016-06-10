module Assignment::UserAssignmentsHelper

  # returns bootstrap label type depending on resp status & possible statuses
  def hf_status_label_color ur
    status_possibilities = ur.user_assignment.status_hash.length
    status_index = ur.user_assignment.status_hash.invert[ur.status][1].to_i - 1

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
  end

  def hf_category_status_label responses
    label_kls, label_text = category_status_calculator(responses)
    return "<span class=\"label label-#{label_kls}\">#{label_text}</span>"
  end

  def hf_category_status_button responses, category
    btn_kls, btn_text = category_status_calculator(responses)
    return """
           <button type=\"button\" class=\"btn btn-#{btn_kls} dropdown-toggle\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"false\">
             #{category.titleize}<span class=\"caret\"></span>
           </button>
           """
  end

  # returns { "month": ["ua type", "ua type"] }
  def hf_user_assignment_cycle_hash ur
    hash = {}
    ur.user.user_assignments.each.map {|ua|
      ua.survey_assignment.title.chomp.split(":", 2) }.map {|k, v|
      !hash.key?(k) ? hash[k] = [v] : hash[k] << v
    }
    hash
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
        total += ur.user_assignment.status_hash.length
        actual += ur.user_assignment.status_hash.invert[ur.status][1].to_i - 1
      end
      kls, text = possibilities[(3 * (actual/total.to_f)).floor]
    end
end
