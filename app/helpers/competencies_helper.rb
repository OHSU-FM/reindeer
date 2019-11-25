module CompetenciesHelper

  COMP_CODES = ["ics1", "ics2", "ics3", "ics4", "ics5", "ics6", "ics7","ics8",
                "mk1", "mk2", "mk3", "mk4", "mk5",
                "pbli1", "pbli2", "pbli3", "pbli4", "pbli5", "pbli6", "pbli7", "pbli8",
                "pcp1", "pcp2", "pcp3", "pcp4", "pcp5", "pcp6",
                "pppd1", "pppd2", "pppd3", "pppd4", "pppd5", "pppd6", "pppd7", "pppd8", "pppd9", "pppd10", "pppd11",
                "sbpic1", "sbpic2", "sbpic3", "sbpic4", "sbpic5"]

  ASSESSORS2 = {  "ics1" => 6, "ics2" => 3, "ics3" => 3, "ics4" => 3, "ics5" => 7, "ics6" => 3, "ics7" => 3, "ics8" => 3,
                  "mk1" => 4, "mk2" => 6, "mk3" => 3, "mk4" => 3, "mk5" => 5,
                  "pbli1" => 8, "pbli2" => 4, "pbli3" => 3, "pbli4" => 4, "pbli5" => 3, "pbli6" => 3, "pbli7" => 3, "pbli8" => 3,
                  "pcp1" => 8, "pcp2" => 8, "pcp3" => 8, "pcp4" => 3, "pcp5" => 3, "pcp6" => 3,
                  "pppd1" => 6,"pppd2" => 4,"pppd3" => 3,"pppd4" => 3,"pppd5" => 3,"pppd6" => 3,"pppd7" => 3,"pppd8" => 3,"pppd9" => 8,"pppd10" => 6,"pppd11" => 3,
                  "sbpic1" => 3,"sbpic2" => 3,"sbpic3" => 3,"sbpic4" => 6,"sbpic5" => 3
  }

  COMP_CODES_CC = ["ics1", "ics2", "ics4", "ics5", "ics6", "ics7","ics8",
                   "pppd1", "pppd2", "pppd3", "pppd4", "pppd10", "pppd11",
                   "pbli3", "pbli6", "pbli8","pcp1",
                   "pcp2", "pcp3", "pcp4", "pcp5", "pcp6",
                   "sbpic3"]

   EPA = { "epa1" => ["pcp1", "ics1", "ics2", "ics3", "ics4", "pppd1", "pppd2", "pppd3", "pppd7", "pppd10", "sbpic3" ],
           "epa2" => ["pcp1", "pcp2", "pcp3", "mk1", "mk2", "mk3", "pbli1", "ics6", "pppd7", "pppd10", "pppd11", "sbpic3"],
           "epa3" => ["pcp2", "pcp3", "pcp4", "pcp5", "mk2", "mk3", "mk4", "mk5", "pbli3", "pbli4", "ics2", "pppd3", "pppd7", "pppd10", "sbpic2", "sbpic3" ],
           "epa4" => ["pcp3", "pcp4", "mk1", "mk2", "mk3", "pbli1", "pbli3", "pbli4", "ics1", "ics2", "pppd7", "pppd10", "sbpic2", "sbpic3"],
           "epa5" => ["pcp4", "mk5", "ics1", "ics2", "ics5", "ics6", "ics8", "pppd2", "pppd5", "pppd7", "pppd9", "pppd10", "sbpic1", "sbpic3", "sbpic4", "sbpic5"],
           "epa6" => ["pcp4", "pbli1", "pbli2", "ics1", "ics2", "ics6", "ics7", "ics8", "pppd2", "pppd4", "pppd7", "pppd10", "pppd11", "sbpic3", "sbpic4", "sbpic5"],
           "epa7" => ["mk1", "mk2", "mk3", "mk4", "mk5", "pbli1", "pbli2", "pbli3", "pbli4", "pbli5", "pppd7", "pppd10", "sbpic3" ],
           "epa8" => ["ics4", "ics5", "ics6", "ics7", "ics8", "pppd2", "pppd7", "pppd10", "sbpic3", "sbpic4", "sbpic5"],
           "epa9" => ["mk5", "ics3", "ics6", "pppd4", "pppd7", "pppd8", "pppd9", "pppd10", "sbpic3", "sbpic4", "sbpic5"],
           "epa10" => ["pcp1", "pcp2", "pcp3", "pcp4", "pcp6", "mk2", "ics3", "ics6", "ics8", "pppd3", "pppd4", "pppd6", "pppd7", "pppd10", "sbpic3", "sbpic5"],
           "epa11" => ["pcp4", "mk1", "mk2", "mk3", "ics1", "ics2", "ics3", "ics5", "pppd7", "pppd9", "pppd10", "sbpic2", "sbpic3"],
           "epa12" => ["pcp6", "ics1", "ics5", "pppd3", "pppd4", "pppd6", "pppd7", "pppd9", "pppd10", "sbpic3"],
           "epa13" => ["mk5", "pbli2", "pbli5", "pbli6", "pbli8", "ics1", "ics6", "pppd7", "pppd10", "sbpic1", "sbpic3", "sbpic5"]
   }

   EPA_DESC={"EPA1" => "Gather a history and perform a physical examination",
             "EPA2" => "Prioritize a differential diagnosis following a clinical encounter",
             "EPA3" => "Recommend and interpret common diagnostic and screening tests",
             "EPA4" => "Enter and discuss orders and prescriptions",
             "EPA5" => "Document a clinical encounter in the patient record",
             "EPA6" => "Provide an oral presentation of a clinical encounter",
             "EPA7" => "Form clinical questions and retrieve evidence to advance patient care",
             "EPA8" => "Give or receive a patient handover to transition care responsibility",
             "EPA9" => "Collaborate as a member of an interprofessional team",
             "EPA10" => "Recognize a patient requiring urgent or emergent care and initiate evaluation and management",
             "EPA11" => "Obtain informed consent for tests and/or procedures",
             "EPA12" => "Perform general procedures of a physician ",
             "EPA13" => "Identify system failures and contribute to a culture of safety and improvement"
   }

   COMP_DOMAIN_DESC = {
                       "ICS" => "Demonstrate interpersonal and communication skills that result in the effective exchange of information and collaboration with patients, their families, and health professionals.",
                       "MK" => "Demonstrate knowledge of established and evolving biomedical, clinical, epidemiological, and social-behavioral sciences, as well as the application of this knowledge to patient care.",
                       "PBLI" => "Demonstrate the ability to investigate and evaluate the care provided to patients, to appraise and assimilate scientific evidence, and to continuously improve patient care based on analysis of performance data, self-evaluation, and lifelong learning.",
                       "PCP" => "Provide patient-centered care that is compassionate, appropriate, and effective for the treatment of health problems and the promotion of health.",
                       "PPPD" => "Demonstrate a commitment to carrying out professional responsibilities, an adherence to ethical principles, and the qualities required to sustain lifelong personal and professional growth.",
                       "SBPIC" => "Demonstrate an awareness of and responsiveness to the larger context and system of healthcare, as well as the ability to effectively call upon other resources in the system to provide optimal care, including engaging in interprofessional teams in a manner that optimizes safe, effective patient and population-centered care."
   }

   COMP_DOMAIN = {  "ics"  => ["ics1", "ics2", "ics3", "ics4", "ics5", "ics6", "ics7", "ics8"],
                    "mk"   => ["mk1", "mk2", "mk3", "mk4", "mk5"],
                    "pbli" => ["pbli1", "pbli2", "pbli3", "pbli4", "pbli5", "pbli6", "pbli7", "pbli8"],
                    "pcp"  => ["pcp1", "pcp2", "pcp3", "pcp4", "pcp5", "pcp6"],
                    "pppd" => ["pppd1", "pppd2", "pppd3", "pppd4", "pppd5", "pppd6", "pppd7", "pppd8", "pppd9", "pppd10", "pppd11"],
                    "sbpic"=> ["sbpic1", "sbpic2", "sbpic3", "sbpic4", "sbpic5"]
   }


  #===================================================================================================================================================================
  def hf_comp_domain
    return COMP_DOMAIN_DESC
  end

  def hf_comp_domain_desc2(code)
    return COMP_DOMAIN_DESC["#{code}"]
  end

  def hf_epa_asessors
    return ASSESSORS2
  end

  def hf_get_epa_desc2 in_code
    return EPA_DESC["#{in_code}"]
  end

  def hf_final_grade2 json_str
    begin
      arry = JSON.parse(json_str)
      return arry["Grade"]
    rescue
      return json_str
    end
  end

  def hf_compute_domain_ave(comp_hash3, domain_comp_codes)
       ave_comp = hf_average_comp2 (comp_hash3)
       cnt = domain_comp_codes.count
       ave = 0
       total = 0
       domain_comp_codes.map!(&:downcase)
       domain_comp_codes.each do |code|
         total += ave_comp[code]
       end
       ave = (total.to_f/cnt).round(0)
       return ave
  end


  def hf_format_final_grade json_str
    begin
      arry = JSON.parse(json_str)
      long_str = ""
      long_str += "<table style='width:180px'>"
      arry.each do |key, value|
        key = key.split(": ").second
        if key.nil?
          key = "Grade"
        end
        long_str += "<tr><td style='text-align:left'>#{key}</td><td>#{value}</td><tr>"
      end
      long_str += "</table>"
      return long_str
    rescue
      return json_str
    end
  end

  def hf_get_non_clinical_courses2
    non_clinical_courses_arry = []
    pathFile = File.join(Rails.root, 'tmp','non_clinical_courses.txt')
    non_clinical_courses_arry = IO.readlines(pathFile)
    non_clinical_courses_arry.map {|k| k.gsub!("\n", "")}
    return non_clinical_courses_arry
   end

    def hf_load_all_comp2(rs_data, level)
      comp_hash = {}
      COMP_CODES.each do |comp|
        comp_hash[comp] = 0
      end
      rs_data.each do |rec|
        COMP_CODES.each do |comp|
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
      #binding.pry
      return comp_hash
    end

    def hf_average_comp2 (comp_hash3)
      percent_complete_hash = {}
      COMP_CODES.each do |comp|
        percent_complete_hash[comp] = 0.0
      end
      percent_complete = 0.0
      comp_hash3.each do |index, value|
        percent_complete = ((value.to_f/ASSESSORS2[index])*100).round(0)
        if percent_complete >= 100
          percent_complete_hash[index] = 100
        else
          percent_complete_hash[index] = percent_complete
        end
      end
      return percent_complete_hash
    end

    def get_unique_student_id2 rs_data_unfiltered
      return rs_data_unfiltered.uniq{|e| e["student_uid"] }
    end

    def get_courses2(studentID, rs_data_unfiltered)
      return rs_data_unfiltered.select {|c| c["student_uid"] == studentID }
    end

    def check_clinical_comp2(in_course, in_level, in_comp_code)
      course_code = in_course.split("]")
      course_code[0] = course_code[0].gsub("[", "")
      if @non_clinical_course_arry.include?(course_code[0]) and in_level == "3" and COMP_CODES_CC.include?(in_comp_code)
          #puts "in_course: " + course_code[0] + " in_comp_code: " + in_comp_code + " level: " + in_level
          return false
      else
          return true
      end
    end

    def hf_load_all_competencies2(rs_data, level)
      comp_hash = {}
      COMP_CODES.each do |comp|
        comp_hash[comp] = 0
      end
      rs_data.each do |rec|
        COMP_CODES.each do |comp|
          if rec[comp].to_s != ""
            #temp_level = rec[comp].split("~")
            if rec[comp] == level and check_clinical_comp2(rec["course_name"], level, comp)
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

    def hf_competency_class_mean2(rs_data_unfiltered)
      courses = {}
      students_comp = {}
      temp_comp = []
      uniq_students = get_unique_student_id2(rs_data_unfiltered)
      uniq_students.each do |k, v|
        rs_courses = get_courses2(k["student_uid"], rs_data_unfiltered)
        comp_hash3 = hf_load_all_competencies2(rs_courses, 3)
        ave_comp_per_student   = hf_average_comp2(comp_hash3)
        students_comp[k["student_uid"]] = ave_comp_per_student
      end

      temp_comp_hash = {}
      COMP_CODES.each do |comp|
        temp_comp_hash[comp] = 0.0
      end
      students_comp.each do |k,v|
        v.each do |key, val|
          temp_comp_hash[key] += val
        end
      end
      class_mean_comp_hash = {}
      temp_comp_hash.each do |k,v|
        class_mean = (v/students_comp.count.to_f).round(0)
        if class_mean > 100
          class_mean_comp_hash[k] = 100
        else
          class_mean_comp_hash[k] = class_mean
        end

      end

      return class_mean_comp_hash
    end

    def hf_epa_level3_detail (rs_data, epa_id, level)
      epa = {}
      epa_code = "epa" + epa_id

      EPA[epa_code].each do |c|
        epa[c] = 0
      end

      rs_data.each do |rec|
        EPA[epa_code].each do |comp|
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

    def hf_epa_level(rs_data, epa_id, level)
      epa = {}
      epa_code = "epa" + epa_id

      EPA[epa_code].each do |c|
        epa[c] = 0
      end

      rs_data.each do |key, value|
        EPA[epa_code].each do |comp|
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

    def hf_epa2(comp_data)
      epa = {}
      for i in 1..13
         epa_code = "epa" + i.to_s
          temp_percent = 0
          EPA[epa_code].each do |c|
            temp_percent = temp_percent + comp_data[c]
          end
          epa[epa_code] = (temp_percent/EPA[epa_code].count.to_f).round(0)
      end
      return epa
    end

    def get_4_random_colors
      color_array = []
      for j in 0..12
        color_array.push "#" + "#{SecureRandom.hex(3)}"
      end
      return color_array
    end


    def domain_colors in_series
      temp_arry = []
      temp_data = {}

      for i in 0..7 do  # ICS
        temp_data = {y: in_series[i], color: '#BCD640'}
        temp_arry.push temp_data
      end
      for i in 8..12 do  # MK
        temp_data = {y: in_series[i], color: '#E09E51'}
        temp_arry.push temp_data
      end
      for i in 13..20 do  # PBLI
        temp_data = {y: in_series[i], color: '#C73293'}
        temp_arry.push temp_data
      end
      for i in 21..26 do  # PCP
        temp_data = {y: in_series[i], color: '#2C48DE'}
        temp_arry.push temp_data
      end
      for i in 27..37 do  # PPPD
        temp_data = {y: in_series[i], color: '#42D68D'}
        temp_arry.push temp_data
      end
      for i in 38..42 do  # SBPIC
        temp_data = {y: in_series[i], color: '#FF408F'}
        temp_arry.push temp_data
      end

      return temp_arry
    end

    def hf_create_chart (type, series1, series2, student_name)
      data_series1 = series1.values
      data_series2 = series2.values
      categories = series2.keys.map{|c| c.upcase}
      if type == "EPA"
        title = "EPA"
      elsif type.include? "FoM"
        title = type
      else
        data_series1 = domain_colors(data_series1)
        title = "Competency"
      end

          chart = LazyHighCharts::HighChart.new('graph') do |f|
            f.title(text: "#{title} for " + "<i>#{student_name}" + '</i>'.html_safe)
            #f.subtitle(text: '<br />Total # of WBAs: <b>' + total_wba_count.to_s + '</b>')
            f.xAxis(categories: categories,
              labels: {
                        style:  {
                                    fontWeight: 'bold',
                                    color: '#000000'
                                }
                      }
            )
            f.series(name: "#{student_name}", yAxis: 0, data: data_series1)
            if type != "EPA"
              f.series(name: "Class Mean", yAxis: 0, data: data_series2, type: 'scatter',
                color: 'black',
                marker: { symbol: 'diamond' })
            else
              f.series(name: "Class Mean", yAxis: 0, color: 'gray', data: data_series2)
            end
            # ["#FA6735", "#3F0E82", "#1DA877", "#EF4E49"]
            f.colors(get_4_random_colors)

            f.yAxis [
               { max: 100,
                 min: 0,
                 tickInterval: 20,
                 title: {text: "<b>#{title} %", margin: 20}
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
              scatter: {
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
            f.chart({
                      defaultSeriesType: "column",
                      width: 1400, height:600,
                      plotBackgroundImage: ''
                    })
          end

          return chart
    end

   def check_series in_series
     temp_arry = []
     temp_data = {}
     in_series.each do |val|
       if val >= 70
         temp_arry.push val
       else
         temp_data = {y: val, color: '#FF4B44'}
         temp_arry.push temp_data
       end
     end
     return temp_arry
   end

    def hf_create_chart_fom (type, series1, series2, student_name, series_color)
      data_series1 = check_series(series1)
      data_series2 = series2
      categories = @category_labels
      if type.include? "Comp2" or type.include? "Comp5"
        categories = ["FUND-HSS", "FUND-BSS", "BLHD-HSS", "BLHD-BSS", "SBM-HSS", "SBM-BSS", "CPR-HSS", "CPR-BSS",  "HODI-HSS", "HODI-BSS", "NSF-HSS", "NSF-BSS", "DEVH-HSS" , "DEVH-BSS"]
        data_series1 = check_series(series1)
        data_series2 = series2
      end

        title = type

          chart = LazyHighCharts::HighChart.new('graph') do |f|
            f.title(text: "<b>#{title}" + "<br/>" + "#{student_name}" + '</b>' )
            #f.subtitle(text: '<br />Total # of WBAs: <b>' + total_wba_count.to_s + '</b>')
            f.xAxis(categories: categories,
              labels: {
                        style:  {
                                    fontWeight: 'bold',
                                    color: '#000000'
                                }
                      }
            )
            f.series(name: "#{student_name}", yAxis: 0, data: data_series1, color: series_color)
            f.series(name: "Class Mean", yAxis: 0, data: data_series2, type: 'scatter',
              color: 'black',
              marker: { symbol: 'diamond' })
            # ["#FA6735", "#3F0E82", "#1DA877", "#EF4E49"]
            f.colors(get_4_random_colors)

            f.yAxis [
               { max: 100,
                 min: 0,
                 tickInterval: 50,
                 title: {text: "<b>#{title} %", margin: 20}
               }
            ]
            f.plot_options(

              column: {
                  dataLabels: {
                      enabled: false,
                      crop: false,
                      overflow: 'none'
                  }
              },

              series: {
                cursor: 'pointer',
                pointWidth: 15

              }
            )

            f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0)
            f.chart({
                      defaultSeriesType: "column",
                      width: 580, height:300,
                      plotBackgroundImage: ''
                    })
          end

          return chart
    end

end
