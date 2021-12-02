module Coaching::StudentsHelper

  # returns true if this cohort contains the selected student
  # @param {Cohort} cohort
  # @param {User} student
  # @return {Boolean}

  WEEKDAYS = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

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
    return [["meeting"], ["introduction"], ["Academic Advising"],
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
    # if  current_user.coaching_type == 'student'
    #   return " #{current_user.full_name} - #{hf_get_cohort(current_user)}"
    # elsif current_user.coaching_type == 'admin' and params[:email].present?
    #   @student = User.find_by("email = ?", params[:email])
    #   return "Student: #{@student.full_name} - #{hf_get_cohort(@student)}"
    # elsif current_user.coaching_type == 'dean' and params[:slug].present?
    #   @student = User.find_by("username = ?", params[:slug])
    #   return "Student: #{@student.full_name} - #{hf_get_cohort(@student)}"
    # else
    #   return "Student: #{@student.full_name} - #{hf_get_cohort(@student)}"
    # end

    if params[:slug].present?
      student = User.find_by("username = ?", params[:slug])
      if student.coaching_type == 'student'
        no_of_wbas = student.epas.where.not(involvement: 0).count.to_s
        no_of_badges = student.epa_masters.where('status = ? and updated_at < ?','Badge', hf_releaseDate(student)).count.to_s
        return ("Student: #{@student.full_name} - #{hf_get_cohort(@student)} " +
               "<span style='font-size:20px;color:black'> (Total # of WBAs: <b>#{no_of_wbas}</b> " +
               "out of 100 & Total # of Badges Awarded: <b>#{no_of_badges}</b> out of 13)</span>").html_safe
      else
        return ""
      end
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
    elsif student.permission_group.title.include? "Med26"
      return "MD26"
    else
      return "Invalid Cohort!"
    end
  end

  def hf_get_full_name(user_id)
      user = User.find(user_id)
      permission_group_title = user.permission_group.title.scan(/\((.*)\)/).first.first
      return user.full_name, permission_group_title
  end

  def hf_get_advisor_name(meetings)
    if meetings.is_a? Integer
      return Advisor.find(meetings).name
    end

    new_meetings = {}

    meetings.each do |key, value|
      new_meetings.store("#{Advisor.find(key).name}", value)
    end

    new_meetings.delete("Coach")

    return new_meetings.sort_by(&:zip)

  end


  def hf_create_oasis_weekdays_graph(weekdays_sorted)

    tot_count = weekdays_sorted.values.sum
    weekdays_series = []
    WEEKDAYS.each do |weekday|
      weekdays_series.push weekdays_sorted["#{weekday}"]
    end
    selected_categories = WEEKDAYS
    height = 400

    title =  "Appointments by Weekdays" + '<br ><b>' + "(n = #{tot_count})" + '</b>'

    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: title)
      #f.subtitle(text: '<br /><h4>Student: <b>' + student_name + '</h4></b>')
      f.xAxis(categories: selected_categories,
        labels: {
              style:  {
                          fontWeight: 'bold',
                          color: '#000000'
                      }
                }
      )
      f.series(name: "Weekday", yAxis: 0, data: weekdays_series)
      # ["#FA6735", "#3F0E82", "#1DA877", "#EF4E49"]
      f.colors(['#4572A7',
                '#AA4643',
                '#89A54E',
                '#80699B',
                '#3D96AE',
                '#DB843D',
                '#92A8CD',
                '#A47D7C',
                '#B5CA92'])

      f.yAxis [
         { tickInterval: 20,
           title: {text: "<b>No of Appointments</b>", margin: 20}
         }
      ]
      f.plot_options(
        column: {
            colorByPoint: true,
            dataLabels: {
                enabled: true,
                crop: false,
                overflow: 'none'
            }
        },
        series: {
          cursor: 'pointer'
        }
      )
      f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0)
      #f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({
                defaultSeriesType: "column",
                width: 800, height: height,
                plotBorderWidth: 0,
                borderWidth: 0,
                plotShadow: false,
                borderColor: '',
                plotBackgroundImage: ''
              })
    end

    return chart

  end

  def hf_create_oasis_hours_graph(hours_sorted)

    tot_count = hours_sorted.values.sum
    height = 400

    am_hash = hours_sorted.select{|key, val| val if key.include? "AM"}
    pm_hash = hours_sorted.select{|key, val| val if key.include? "PM"}
    pm12_hash = hours_sorted.select{|key, val| val if key.include? "12 PM"}


    selected_categories = (am_hash.keys + pm12_hash.keys +  pm_hash.keys)
    hours_series = (am_hash.values + pm12_hash.values + pm_hash.values)

    selected_categories.pop  #remove the last item, 12pm  as it is redundant
    hours_series.pop         #remove the last item value (12pm) as it is redundant

    title =  "Appointments by Hours" + '<br ><b>' + "(n = #{tot_count})" + '</b>'
    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: title)
      #f.subtitle(text: '<br /><h4>Student: <b>' + student_name + '</h4></b>')
      f.xAxis(categories: selected_categories,
        labels: {
              style:  {
                          fontWeight: 'bold',
                          color: '#000000'
                      }
                }
      )
      f.series(name: "By Hours", yAxis: 0, data: hours_series)
      # ["#FA6735", "#3F0E82", "#1DA877", "#EF4E49"]
      f.colors(['#4572A7',
                '#AA4643',
                '#89A54E',
                '#80699B',
                '#3D96AE',
                '#DB843D',
                '#92A8CD',
                '#A47D7C',
                '#B5CA92'])

      f.yAxis [
         { tickInterval: 20,
           title: {text: "<b>No of Appointments</b>", margin: 20}
         }
      ]
      f.plot_options(
        column: {
            colorByPoint: true,
            dataLabels: {
                enabled: true,
                crop: false,
                overflow: 'none'
            }
        },
        series: {
          cursor: 'pointer'
        }
      )
      f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0)
      #f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({
                defaultSeriesType: "column",
                width: 800, height: height,
                plotBorderWidth: 0,
                borderWidth: 0,
                plotShadow: false,
                borderColor: '',
                plotBackgroundImage: ''
              })
    end

    return chart

  end
end
