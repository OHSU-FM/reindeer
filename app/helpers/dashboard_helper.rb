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
    fa_icon = content_tag :i, "", class: "fa fa-upload", style: "color:#7A7F7C"
    text = raw "#{fa_icon } #{text} #{badge}"
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
    elsif current_user.coaching_type == 'dean' #and meetings.empty?
        advisor = Advisor.find_by(email: current_user.email)
        if advisor.nil?
          return []
        end
        meetings = Coaching::Meeting.where(advisor_id: advisor.id)
        events_array = []
        meetings.each do |meeting|
          events = Event.where("id = ? and start_date > ? and user_id is not NULL", meeting.event_id, DateTime.now)
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

  def scan_test(fom_exams, full_name, sid)

    tot_failed_tests = 0
    block_hash = {}
    all_blocks = []
    student_hash = {}

    tot_failed_hash = {}
    fom_exams.each do |exam|
      comp1 = exam.select{|key, val| val if key.include? "comp1_wk"}.select{|key, val| val if val < 70.0 }
      comp2a = exam.select{|key, val| val if key.include? "comp2a"}.select{|key, val| val if val < 70.0 }
      comp2b = exam.select{|key, val| val if key.include? "comp2b" and key.include? "Average" }.select{|key, val| val if val < 70.0 }
      comp3 = exam.select{|key, val| val if key.include? "comp3_"}.select{|key, val| val if val < 70.0 }
      comp4 = exam.select{|key, val| val if key.include? "comp4_"}.select{|key, val| val if val < 70.0 }
      comp5a = exam.select{|key, val| val if key.include? "comp5a_hss"}.select{|key, val| val if val < 70.0 }
      comp5b = exam.select{|key, val| val if key.include? "comp5b_bss"}.select{|key, val| val if val < 70.0 }
      tot_failed_tests = comp1.count + comp2a.count + comp2b.count + comp3.count + comp4.count + comp5a.count + comp5b.count
      block_hash.store(exam["course_code"], tot_failed_tests)
      tot_failed_tests = 0
    end

    if block_hash.values.sum > 2
      #block_hash.store("TotalFailed", block_hash.values.sum)
      student_hash.store(full_name, block_hash)
      student_hash.store('sid', sid)
      all_blocks.push student_hash
      tot_failed_hash.store("full_name", full_name)
      tot_failed_hash.store("TotalFailed", block_hash.values.sum)

    else
      return [], {}
    end
    return all_blocks, tot_failed_hash

  end

  def hf_scan_fom_data(permission_group_id)
    students_array = []
    tot_failed_arry = []
    #users = User.where(username: 'languyen').select(:id, :full_name, :sid, :email)
    users = User.where(permission_group_id: 19).select(:id, :full_name, :sid, :email)
    users.each do |user|
      fom_exams = FomExam.where(user_id: user.id).order(:course_code)
      fom_exams = fom_exams.to_a.map(&:serializable_hash)
      failed_tests, tot_failed_hash = scan_test(fom_exams, user.full_name, user.sid)
      if !failed_tests.empty?
        #puts failed_tests.flatten.inspect
        students_array.push failed_tests
        tot_failed_arry.push tot_failed_hash

      end

    end
    students_array = students_array.flatten.sort_by{|key, val| val}
    tot_failed_arry = tot_failed_arry.sort_by{|val| val["TotalFailed"]}.reverse
    # tot_failed_arry.each do |student|
    #   puts student.inspect
    # end
    return students_array, tot_failed_arry

  end

  def hf_get_fom_blocks(student_sid)
    student_all_blocks = User.find_by(sid: student_sid).fom_exams.order(:course_code)
    return student_all_blocks
  end

  def get_FomLabels(permission_group_id, course_code)
    fom_labels = FomLabel.find_by(permission_group_id: permission_group_id, course_code: course_code)
    return JSON.parse(fom_labels["labels"]).first  ## return as hash array

  end


  def hf_get_failed_exams(fom_exams)
    fom_exams = fom_exams.to_a.map(&:serializable_hash)
    failed_exams_hash = {}
    @labels_hash = {}
    fom_exams.each do |exam|
      comp1 = exam.select{|key, val| val if key.include? "comp1_wk"}.select{|key, val| val if val < 70.0 }
      comp2a = exam.select{|key, val| val if key.include? "comp2a"}.select{|key, val| val if val < 70.0 }
      comp2b = exam.select{|key, val| val if key.include? "comp2b" and key.include? "Average" }.select{|key, val| val if val < 70.0 }
      comp3 = exam.select{|key, val| val if key.include? "comp3_"}.select{|key, val| val if val < 70.0 }
      comp4 = exam.select{|key, val| val if key.include? "comp4_"}.select{|key, val| val if val < 70.0 }
      comp5a = exam.select{|key, val| val if key.include? "comp5a_hss"}.select{|key, val| val if val < 70.0 }
      comp5b = exam.select{|key, val| val if key.include? "comp5b_bss"}.select{|key, val| val if val < 70.0 }


      failed_exams_hash.store(exam["course_code"], {comp1: comp1, comp2a: comp2a, comp3: comp3, comp4: comp4, comp5a: comp5a, comp5b: comp5b})
      labels = get_FomLabels(exam["permission_group_id"], exam["course_code"])
      @labels_hash.store(exam["course_code"], labels)

    end

    return failed_exams_hash
  end
end
