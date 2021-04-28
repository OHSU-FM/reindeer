module AdvisorsHelper
  def hf_advisor_type in_user
    advisor_type = Advisor.find_by(email: in_user+'@ohsu.edu').advisor_type
    byebug
    return advisor_type
  end
end
