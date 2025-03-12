module NewCompetenciesHelper

  NEW_COMP_ASSESSORS = {
    "ics1" => 3,
    "ics2" => 3,
    "ics3" => 3,
    "ics4" => 1,
    "ics5" => 2,
    "mk1" => 3,
    "mk2" => 3,
    "mk3" => 3,
    "pbli1" => 3,
    "pbli2" => 3,
    "pbli3" => 1,
    "pcp1" => 3,
    "pcp2" => 3,
    "pcp3" => 2,
    "pppd1" => 1,
    "pppd2" => 3,
    "sbp1" => 1
  }

  NEW_COMP_DEFINITION = {
    "ics1" => "Communicate effectively with patients and families.",
    "ics2" => "Communicate effectively with physicians and physicians in training.",
    "ics3" => "Collaborate effectively with non-physician health professionals as a part of healthcare team to coordinate patient care.",
    "ics4" => "Communicate a patient handover to transition responsibility of care.",
    "ics5" => "Access, review, and contribute to the electronic health record and other technologies.",
    "mk1" => "Demonstrate foundational knowledge in basic science.",
    "mk2" => "Demonstrate foundational knowledge in clinical science.",
    "mk3" => "Demonstrate foundational knowledge in health systems science.",
    "pbli1" => "Demonstrate behaviors that support lifelong learning and professional growth such as incorporating self-assessment and feedback.",
    "pbli2" => "Locate, critically appraise, and synthesize new information to support evidence informed and patient centered clinical decisions.",
    "pbli3" => "Engage in scholarly inq@comp_data_clinicaluiry and disseminate findings using ethical principles.",
    "pcp1" => "Gather information through history and physical on patients.",
    "pcp2" => "Construct prioritized differential diagnosis based on interpretation of available clinical data.",
    "pcp3" => "Develop and implement a personalized management plan for the patient.",
    "pppd1" => "Identify and address the negative effects of structural and social determinants of health for patients with diverse needs.",
    "pppd2" => "Demonstrate behaviors that are reflective of professional values of truthfulness, timeliness, accountability, and follow through.",
    "sbp1" => "Engage in the quality improvement process related to patient safety and system issues."

  }

  NEW_COMP_CODES = ["ics1", "ics2", "ics3", "ics4", "ics5", "mk1", "mk2", "mk3", "pbli1", "pbli2", "pbli3", "pcp1", "pcp2", "pcp3", "pppd1", "pppd2",  "sbp1"]

   NEW_EPA = {
        "epa1a" => ["pcp1", "pcp2", "pcp3", "mk1", "mk2", "ics1", "ics5", "pppd1", "pppd2"], #done
        "epa1b" => ["pcp1", "pcp2", "mk2", "ics1", "ics5", "pppd2"], #done
        "epa2" => ["pcp1", "pcp2",  "mk1", "mk2", "ics5", "pbli1", "pppd1", "pppd2"],  # done
        "epa3" => ["pcp2",  "mk1", "mk2", "mk3",  "pbli2", "ics2", "ics5", "pppd2"], #done
        "epa4" => ["pcp3", "mk1", "mk2", "mk3", "ics1", "ics3", "ics5", "pbli2", "sbp1", "pppd2"], #done
        "epa5" => ["pcp1", "pcp2", "pcp3", "mk1", "mk2", "mk3", "pbli2",  "ics2", "ics3", "ics4", "ics5", "pppd2"], # done
        "epa6" => ["pcp1", "pcp2", "pcp3", "mk1", "mk2", "mk3", "ics1", "ics2", "ics3", "pbli1", "pbli2", "pppd1", "pppd2"], #done
        "epa7" => ["pcp1", "pcp2", "pcp3", "mk1", "mk2", "mk3",  "pbli1", "pbli2", "ics2", "ics3", "ics5", "pppd1", "pppd2" ], #done
        "epa8" => ["pcp1", "pcp2", "pcp3", "mk2", "ics2", "ics3",  "ics4"],  #done
        "epa9" => ["pcp3", "mk2", "mk3", "sbp1", "ics1", "ics3", "ics5", "pppd1", "pppd2"], # done
        "epa10" => ["pcp1", "pcp2", "pcp3",  "mk2", "sbp1", "ics1", "ics2", "ics3", "ics4", "ics5", "pppd2"], #done
        "epa11" => ["pcp2", "pcp3", "mk1", "mk2", "mk3", "ics1", "ics5", "pbli2", "pppd1", "pppd2"] #done
      }

   NEW_EPA_ARRAY = ["epa1a", "epa1b", "epa2", "epa3", "epa4", "epa5", "epa6", "epa7", "epa8", "epa9", "epa10", "epa11" ]
   NEW_EPA_ARRAY_EXTRA = ["epa1a&1b", "epa1a", "epa1b", "epa2", "epa3", "epa4", "epa5", "epa6", "epa7", "epa8", "epa9", "epa10", "epa11" ]

   NEW_EPA_DESC={
             "EPA1A" => "Obtain a hypothesis-driven history",
             "EPA1B" => "Perform a tailored physical examination",
             "EPA2" => "Generate a prioritized differential diagnosis for a clinical encounter",
             "EPA3" => "Interpret Diagnostic or screening tests for a clinical encounter",
             "EPA4" => "Enter orders including prescriptions for a clinical encounter",
             "EPA5" => "Document a clinical encounter in the patient record",
             "EPA6" => "Provide an oral presentation of a clinical encounter",
             "EPA7" => "Use literature to make a patient care recommendation",
             "EPA8" => "Communicate a patient handover to transition responsibility of care",
             "EPA9" => "Advance patient care through interprofessional collaboration",
             "EPA10" => "Recognize a patient requiring urgent assessment and escalate care",
             "EPA11" => "Lead shared decision making discussions for patient care "

   }

   #============ New Updated EPA Definiation - from Logan Jones
   # EPA 1:  Split into two EPAs Below
   # EPA 1a Obtain a hypothesis-driven history
   # EPA 1b Perform a tailored physical examination
   # EPA 2: Generate a prioritized differential diagnosis for a clinical encounter  (Updated language)
   # EPA 3:   Interpret Diagnostic or Screening Tests  (Updated language)
   # EPA 4:   Enter orders including prescriptions.  (Updated language)
   # EPA 5:   Document a clinical encounter in the patient record  - Keep
   # EPA 6: Provide an oral presentation of a clinical encounter - Keep
   # EPA 7:  Use literature to make a patient care recommendation (Updated language)
   # EPA 8:  Communicate a patient handover to transition responsibility of care (Updated Language)
   # EPA 9:  Advance patient care through interprofessional collaboration  (Updated language)
   # EPA 10:  Recognize a patient requiring urgent assessment and escalate care  (Updated language)
   # EPA 11:  Lead Shared Decision Making Discussions For Patient Care (Updated language)
   # EPA 12: Perform general procedures of a physician  - REMOVED
   # EPA 13: Identify system failures and contribute to a culture of safety and improvement   REMOVED
   def hf_GetNewEPA
     return NEW_EPA_ARRAY
   end

   def hf_get_new_epa_desc(epa_code)
     return NEW_EPA_DESC[epa_code]
   end

   def hf_new_epa_assessors
     return NEW_COMP_ASSESSORS
   end

   def hf_new_epa_level(rs_data, epa_code, level)
     epa = {}

     NEW_EPA[epa_code].each do |c|
       epa[c] = 0
     end

     rs_data.each do |key, value|
       NEW_EPA[epa_code].each do |comp|
         if !value.nil?
           if (value == level.to_i) and (key==comp)
             epa[comp] += 1
           elsif value.to_i > 3 and (key==comp)
             temp_val = value.to_f/3.0
             epa[comp] = epa[comp] + temp_val.round
           end
         end
       end
     end
     return epa
   end

   def hf_new_epa_level3_detail (rs_data, epa_code, level)
     epa = {}

     NEW_EPA[epa_code].each do |c|
       epa[c] = 0
     end

     rs_data.each do |rec|
       NEW_EPA[epa_code].each do |comp|
         if !rec[comp].nil?
           if (rec[comp] == level.to_i)
             epa[comp] += 1
           elsif rec[comp].to_i > 3
             temp_val = rec[comp].to_f/3.0
             epa[comp] = epa[comp] + temp_val.round
           end
         end
       end
     end
     return epa
   end

   def hf_new_comp(rs_data, level)
     comp_hash = {}
     NEW_COMP_CODES.each do |comp|
       comp_hash[comp] = 0
     end
     rs_data.each do |rec|
       NEW_COMP_CODES.each do |comp|
         if rec[comp].to_s != ""
           #temp_level = rec[comp].to_s.split("~")
           if rec[comp] == level
             comp_hash[comp] += 1
           elsif level == 3 and rec[comp] > 3
             temp_val = rec[comp].to_f/3.0
             comp_hash[comp] = comp_hash[comp] + temp_val.round
           end
         end
       end
     end
     return comp_hash
   end

   def hf_average_comp_new (comp_hash3)
     percent_complete_hash = {}
     NEW_COMP_CODES.each do |comp|
       percent_complete_hash[comp] = 0.0
     end
     percent_complete = 0.0
     comp_hash3.each do |index, value|
       percent_complete = ((value.to_f/NEW_COMP_ASSESSORS[index])*100).round(0)
       if percent_complete >= 100
         percent_complete_hash[index] = 100
       else
         percent_complete_hash[index] = percent_complete
       end
     end
     return percent_complete_hash
   end

   def hf_load_all_new_competencies(rs_data, level)
     comp_hash = {}
     NEW_COMP_CODES.each do |comp|
       comp_hash[comp] = 0
     end
     rs_data.each do |rec|
       NEW_COMP_CODES.each do |comp|
         if rec[comp].to_s != ""
           #temp_level = rec[comp].split("~")
           if rec[comp] == level #and check_clinical_comp2(rec["course_name"], level, comp)
             comp_hash[comp] += 1
           elsif level == 3 and rec[comp].to_i > 3
             temp_val = rec[comp].to_f/3.0
             comp_hash[comp] = comp_hash[comp] + temp_val.round
           end
         end
       end
     end
     #binding.pry
     return comp_hash
   end

    def hf_new_comp_by_cohort(permission_group_id)
      cohort_competency = []
      # This will grab all competencies based on the criteria
      # competencies = User.where("users.permission_group_id=20 and users.new_competency=true").
      #                 select(:id, :full_name, :sid, :email).
      #                 joins(:new_competencies).select("new_competencies.*")
      users = User.where(permission_group_id: permission_group_id, new_competency: true).select(:id, :full_name, :email, :sid).order(:full_name)

      users.each do |user|
        comp = user.new_competencies
        comp = comp.map(&:attributes)
        comp_new_hash3 = hf_new_comp(comp, 3)
        comp_new_data_clinical = hf_average_comp_new (comp_new_hash3)
        temp_comp = {}
        temp_comp["StudentName"] = user.full_name
        temp_comp["sid"] = user.sid
        temp_comp["email"] = user.email
        temp_comp = temp_comp.merge(comp_new_data_clinical)
        cohort_competency.push temp_comp
      end
      return cohort_competency

    end

   def hf_competency_new_class_mean(rs_data_unfiltered)
     courses = {}
     students_comp = {}
     temp_comp = []
     uniq_students = get_unique_student_id2(rs_data_unfiltered)
     uniq_students.each do |k, v|
       rs_courses = get_courses2(k["student_uid"], rs_data_unfiltered)
       comp_hash3 = hf_load_all_new_competencies(rs_courses, 3)
       ave_comp_per_student   = hf_average_comp_new(comp_hash3)
       students_comp[k["student_uid"]] = ave_comp_per_student
     end

     temp_comp_hash = {}
     NEW_COMP_CODES.each do |comp|
       temp_comp_hash[comp] = 0.0
     end
     students_comp.each do |k,v|
       v.each do |key, val|
         temp_comp_hash[key] += val
       end
     end
     class_mean_comp_hash = {}

     temp_comp_hash.each do |k,v|
       if students_comp.empty?
         class_mean_comp_hash[k] = 0
       elsif
           class_mean = (v/students_comp.count.to_f).round(0)
           if class_mean > 100
             class_mean_comp_hash[k] = 100
           else
             class_mean_comp_hash[k] = class_mean
           end
       end
     end
     return class_mean_comp_hash
   end

  def hf_course_type (competencies, course_type)
    if course_type =='Core'
      selected_competencies = competencies.select{|c| c if c.course_name.include? "Core"}
    elsif course_type == 'Intersessions'
      selected_competencies = competencies.select{|c| c if c.course_name.include? "INTS" and !c.course_name.include? "Testing"}
    elsif course_type == 'Electives'
      selected_competencies = competencies.select{|c| c if !c.course_name.include? "730" and !c.course_name.include? "731" and !c.course_name.include? "770" and \
            !c.course_name.include? "INTS" and !c.course_name.include? "TRAN" and !c.course_name.include? "SCHI" and \
            !c.course_name.include? "FoM" and !c.course_name.include? "CPX"}
    elsif course_type == 'Scholarly'
      selected_competencies = competencies.select{|c| c if c.course_name.include? "SCHI"}
    elsif course_type == 'Transition'
      selected_competencies = competencies.select{|c| c if c.course_name.include? "TRAN"}
    elsif course_type == 'NBME'
      selected_competencies = competencies.select{|c| c if c.course_name.include? "Testing"}
    elsif course_type == 'CPX'
      selected_competencies = competencies.select{|c| c if c.course_name.include? "CPX"}
    elsif course_type == 'AllCourses'
      selected_competencies = competencies

    end

    return selected_competencies
  end

  def hf_new_epa (comp_data)
    epa = {}
    NEW_EPA_ARRAY.each do |epa_code|  #NEW_EPA_ARRAY contains EPA1a, EPA1b, etc..
        temp_percent = 0
        NEW_EPA[epa_code].each do |c|
          temp_percent = temp_percent + comp_data[c]
        end
        epa[epa_code] = (temp_percent/NEW_EPA[epa_code].count.to_f).round(0)
    end
    return epa
  end

  def total_wba_by_epa(results)
    epa_hash3 = {}
    count = 0
    count = results.select{|r| r if r.epa == "EPA1A"}.count
    epa_hash3.store("EPA1A", count)
    count = results.select{|r| r if r.epa == "EPA1B"}.count
    epa_hash3.store("EPA1B", count)
    for i in 2..11 do
        count = 0
        count = results.select{|r| r if r.epa == "EPA#{i}"}.count
        if count != 0
          epa_hash3.store("EPA#{i}", count)
        elsif count == 0
          epa_hash3.store("EPA#{i}", 0)
        end
    end

    return epa_hash3
  end

  def total_by_involvement (results, uniq_clinical_assessors)
    clinical_hash_by_involve = {}
    uniq_clinical_assessors.each do |ca|
      temp_hash = []
      for i in 1..4
        count = results.select{|r| r if r.clinical_assessor == "#{ca}" and r.involvement == i }.count
        temp_hash.push count
      end
      clinical_hash_by_involve.store(ca, temp_hash)
    end
    return clinical_hash_by_involve
  end

  def total_wba_by_clinical_assessors(results)
    clinical_hash = {}
    uniq_clinical_assessors = results.map{|r| r.clinical_assessor}.uniq
    uniq_clinical_assessors.each do |ca|
      count = results.select{|r| r if r.clinical_assessor == "#{ca}" }.count
      if count != 0
        clinical_hash.store("#{ca}", count)
      end
    end

    clinical_hash_by_involve = total_by_involvement(results, uniq_clinical_assessors)
    return clinical_hash, clinical_hash_by_involve
  end

  def hf_get_wbas_involvement(user_id)
    epa = {}
    NEW_EPA_ARRAY.each do |epa_code|
        temp_involve = []
        (1..4).each do |k|
           temp_data = Epa.where(epa: "#{epa_code.upcase}", involvement: k, user_id: user_id).count
           temp_involve.push temp_data
        end
        epa["#{epa_code.upcase}"] = temp_involve
    end

    return epa
  end

  def hf_get_old_wbas_involvement(user_id)
    epa = {}
    (1..13).each do |i|
        epa_code = "EPA#{i}"
        temp_involve = []
        (1..4).each do |k|
           temp_data = Epa.where(epa: "#{epa_code}", involvement: k, user_id: user_id).count
           temp_involve.push temp_data
        end
        epa["#{epa_code}"] = temp_involve
    end

    return epa
  end

  def hf_get_wbas_new(epas)
    #selected_user = User.find_by(email: email)
    #epas = Epa.where(user_id: selected_user.id).order(:epa, :submit_date)
    #epas = User.select(:id, :full_name).where(email: email).first.epas.where("epa <> ? and epa <> ?", "EPA12", "EPA13").order(:epa, :submit_date)

    if !epas.empty?
      total_wba_count = epas.count
      selected_student = epas.first.student_assessed.split("-").first
      #commented it out at the controller
      # epa_hash = total_wba_by_epa(epas)
      epa_hash = {}
      clinical_assessors, clinical_hash_by_involve = total_wba_by_clinical_assessors(epas)
      # epa_hash_dates = reformatted_data(epas)
      # epa_evaluators, unique_evaluators, selected_dates = epas_by_evaluators(epas)
      return epas, epa_hash, clinical_assessors, clinical_hash_by_involve, selected_student, total_wba_count
    else
      return [], {}, {}, {}, 0, 0
    end
  end

  def epa_hash_merge (epa_hash, permission_group_id)
    # we need to show some epas 0 wba
    temp_epa_hash = {}

    if permission_group_id >= 20 && permission_group_id <= 22
      NEW_EPA_ARRAY_EXTRA.each do |epa|
        temp_epa_hash[epa.upcase] = 0
      end
      epa_hash = temp_epa_hash.merge(epa_hash)

    elsif permission_group_id >= 23
      NEW_EPA_ARRAY.each do |epa|
        temp_epa_hash[epa.upcase] = 0
      end
      epa_hash = temp_epa_hash.merge(epa_hash)
    end


    return epa_hash

  end

  def hf_clinical_assessors_graph(wba, user, total_wba_count)
    student_name = user.full_name  # processing student Alver
    #wba_series = wba.values # removed the first 2 items in array
    selected_categories = wba.keys
    tot_attending = wba["Attending Faculty"].sum
    tot_attending_str = "<br /> Total # of WBAs for Attending Faculty: <b>#{tot_attending.to_s}</b>"
    title = "Workbased Assessment by Clinical Assessors - #{student_name}" + '<br /><h4>Total # of WBAs: <b>' + "#{total_wba_count}</b>" + tot_attending_str +
             '</h4>' + '<br>' + "<b>Requirement: At Least 51 Attendings</b>"
    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: title,
               style: {
                 fontSize: '14px'
                 }
              )
      #f.subtitle(text: '<br /><h4>Total # of WBAs: <b>' + wba_series.sum.to_s + '</h4></b>')
      f.xAxis(categories: selected_categories,
        labels: {
              style:  {
                          fontWeight: 'bold',
                          color: '#000000',
                          fontSize: '13px'
                      }
                }
      )
      names = wba.keys
      data = wba.values.transpose

      f.series(name: '1 - I did it', yAxis: 0, data: data[0])
      f.series(name: '2 - I talked them through it', yAxis: 0, data: data[1])
      f.series(name: '3 - I directed them from time to time', yAxis: 0, data: data[2])
      f.series(name: '<b>4 - I was available just in case</b>', yAxis: 0, data: data[3])
      f.yAxis [
         { tickInterval: 20,
           title: {text: "No of WBAs", margin: 20,
              style:  {
                       fontWeight: 'bold',
                       color: '#000000',
                       fontSize: '13px'
                     }
           }
         }
      ]
      f.plot_options(
        column: {
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
                #width: 1100, height: height,
                plotBorderWidth: 0,
                borderWidth: 0,
                plotShadow: false,
                borderColor: '',
                minPadding: 0,
                maxPadding: 0,
                plotBackgroundImage: ''
              })


  end
  return chart
end

  def hf_wba_graph(wba, user, graph_code)

        student_name = user.full_name  # processing student Alver
        wba_series = wba.values # removed the first 2 items in array

        if graph_code == 'NewEPAs'
          title = "NEW EPA Milestone - #{student_name}"
          sub_title = ""
          y_axis_title = "Percentage"
          selected_categories = wba.keys.map(&:upcase)
          caption = ""
        else
          title = "Workbased Assessment Datapoints - #{student_name}"
          sub_title = '<br /><h4>Total # of WBAs: <b>' + wba_series.sum.to_s + '<br>' + "<b>Requirement: At Least 2 WBAs for each EPA</b>"
          y_axis_title = "No of WBAs"
          caption = '<b>Due to the EPAs changes, prior to 7/1/2025 EPA1A & 1B are counted as 1. Starting 7/1/2025, EPA1A & EPA1B will be counted as separately.</b>'
          selected_categories = wba.keys
        end

        height = 400
        color_array = ['#7cb5ec',
            '#f7a35c',
            '#90ee7e',
            '#7798BF',
            '#aaeeee',
            '#ff0066',
            '#eeaaee',
            '#55BF3B',
            '#DF5353',
            '#7798BF',
            '#aaeeee',
            '#000080']
        chart = LazyHighCharts::HighChart.new('graph') do |f|
          f.title(text: title + sub_title + '</h4></b>',
            style: {
              fontSize: '14px'
              }
           )

          #f.subtitle(text: '<br /><h4>Total # of WBAs: <b>' + wba_series.sum.to_s + '</h4></b>')
          f.xAxis(categories: selected_categories,
            labels: {
                  style:  {
                              fontWeight: 'bold',
                              color: '#000000',
                              fontSize: '13px'
                          }
                    }
          )

          f.series(name: "EPA", data: wba_series)
          f.caption(
            text: caption,
            style:  {
                     fontWeight: 'bold',
                     color: 'blue',
                     fontSize: '13px'
                   }

          )

          #f.series(name: "Class Mean", yAxis: 0, data: class_mean_series)

          # ["#FA6735", "#3F0E82", "#1DA877", "#EF4E49"]
          #f.colors(["#7EFF5E", "#6E92FF"])
          f.colors(['#7cb5ec',
              '#f7a35c',
              '#90ee7e',
              '#7798BF',
              '#aaeeee',
              '#ff0066',
              '#eeaaee',
              '#55BF3B',
              '#DF5353',
              '#7798BF',
              '#aaeeee',
              '#000080',
              '#00bfff'])
          f.yAxis [
             { tickInterval: 20,
               title: {text: y_axis_title, margin: 20,
                  style:  {
                           fontWeight: 'bold',
                           color: '#000000',
                           fontSize: '13px'
                         }
               }
             }
          ]
          f.plot_options(
            column: {
                dataLabels: {
                    enabled: true,
                    crop: false,
                    overflow: 'none'
                }
            },
            series: {
              cursor: 'pointer',
              colorByPoint: true  # this is a must to have multi-color col graphs

            }

          )
          f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0)
          #f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
          f.chart({
                    defaultSeriesType: "column",
                    #width: 1100, height: height,
                    plotBorderWidth: 0,
                    borderWidth: 0,
                    plotShadow: false,
                    borderColor: '',
                    minPadding: 0,
                    maxPadding: 0,
                    plotBackgroundImage: ''
                  })


      end
      return chart
  end

end
