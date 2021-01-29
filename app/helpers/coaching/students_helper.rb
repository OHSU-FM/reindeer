module Coaching::StudentsHelper

  # returns true if this cohort contains the selected student
  # @param {Cohort} cohort
  # @param {User} student
  # @return {Boolean}
  def hf_active_cohort? cohort, student
    student.cohort == cohort
  end

  # returns the competency_tag hash with human readable version for translation
  def hf_competency_tags_for_select
    [
      ["Interpersonal & Communication (ICS)", "ics"],
      ["Patient Care & Procedures (PCP)", "pcp"],
      ["Practice Based Learning & Improvement (PBLI)", "pbli"],
      ["Medical Knowledge (MK)", "mk"],
      ["Systems Based Practice & Interprofessional Collaboration (SBPIC)", "sbpic"],
      ["Professionalism and Personal & Professional Development (PPPD)", "pppd"]
    ]
  end

  def hf_meeting_tags_for_select
    return [["Academic Advising"],
              ["Goal Setting/Updating"],
              ["Wellness Check"],
              ["Monitoring EPAs"],
              ["Residency Advising Follow-up"],
              ["USMLE - Step1"],
              ["USMLE - Step 2 CK"],
              ["USMLE - Stpe 2 CS"],
              ["Board Studying"],
              ["Rotation Scheduling"],
              ["Remediation"],
              ["MSPE"],
              ["Other"]]
  end


  # returns the long form human readable version of a competency tag
  # @param {String} c_tag
  # @return {String} long competency tag (ex: Patient Care (PC))
  def hf_tag_to_human c_tag
    hf_competency_tags_for_select.each do |ary|
      return ary.first if ary.second == c_tag
    end
  end

  # returns the short form human readable version of a competency tag
  # @param {String} c_tag
  # @return {String} short competency tag (ex: PC)
  def hf_tag_to_short_human c_tag
    long = hf_tag_to_human c_tag
    return long[/\(([^)]+)\)/].gsub(/[()]/, "")
  end

  def hf_sort_link column, title = nil
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    icon = sort_direction == "asc" ? "glyphicon glyphicon-chevron-up" : "glyphicon glyphicon-chevron-down"
    icon = column == sort_column ? icon : ""
    link_to "#{title} <span class='#{icon}'></span>".html_safe, { column: column, direction: direction }
  end

  def hf_get_label (current_user)
    if  current_user.coaching_type == 'student'
      return " #{current_user.full_name}"
    elsif current_user.coaching_type == 'admin' and params[:email].present?
      @student = User.find_by("email = ?", params[:email])
      return "Student: #{@student.full_name}"
    elsif current_user.coaching_type == 'admin' and params[:slug].present?
      @student = User.find_by("username = ?", params[:slug])
      return "Student: #{@student.full_name}"
    else
      return "Student: #{@student.full_name}"
    end
  end

  def hf_get_cohort student
    if student.permission_group.title.include? "Med18"
      return "MD18"
    elsif student.permission_group.title.include? "Med19"
      return "MD19"
    elsif student.permission_group.title.include? "Med20"
      return "MD20"
    elsif student.permission_group.title.include? "Med21"
      return "MD21"
    elsif student.permission_group.title.include? "Med22"
      return "MD22"
    elsif student.permission_group.title.include? "Med23"
      return "MD23"
    elsif student.permission_group.title.include? "Med24"
      return "MD24"
    elsif student.permission_group.title.include? "Med25"
      return "MD25"
    else
      return "Test User"
    end
  end


end
