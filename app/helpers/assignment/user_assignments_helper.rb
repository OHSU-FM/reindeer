module Assignment::UserAssignmentsHelper

  # returns bootstrap label type depending on resp status & possible statuses
  def status_label_color ur
    status_possibilities = ur.user_assignment.status_hash.length
    case status_possibilities
    when 2
      possibilities = ["danger", "success"]
    when 3
      possibilities = ["danger", "primary", "success"]
    when 4
      possibilities = ["danger", "warning", "primary", "success"]
    else
      possibilities = ["danger", "warning", "info", "primary", "success"]
    end
    status_index = ur.user_assignment.status_hash.invert[ur.status][1].to_i - 1
    possibilities[status_index * (status_possibilities / possibilities.length)]
  end
end
