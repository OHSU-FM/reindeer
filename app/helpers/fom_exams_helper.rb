module FomExamsHelper

COMPONENT_DESC = {'comp1_wk' => 'Component 1: Medical Knowledge (Weekly Tests/Quizzes)',
                  'comp2a_hss' => 'Component 2A: Clinical/Health Systems Science Skills Assessments',
                  'comp2b_bss' => 'Component 2B: Basic Science Skills Assessments',
                  'comp3_final' => 'Component 3: Final Block Exam',
                  'comp4_nbme' => 'Component 4: NBME Exam',
                  'comp5a_hss' => 'Component 5A: Clinical/Health Systems Science Skills Assessments',
                  'comp5b_bss' => 'Component 5B: Basic Science Skills Assessment',
                  'summary_comp' => 'Summary Data'
                }
COMPONENT_DESC_MED21 = {'comp1_wk' => 'Component 1: Medical Knowledge (Weekly Tests/Quizzes)',
                  'comp2b_bss' => 'Component 2: Basic Science Skills Assessments',
                  'comp3_final' => 'Component 3: Final Block Exam',
                  'comp4_nbme' => 'Component 4: NBME Exam',
                  'comp5a_hss' => 'Pathology & Histology',
                  'comp5b_bss' => 'Component 5: Basic Science Skills Assessment',
                  'summary_comp' => 'Summary Data'
                }


BLOCKS = {  '1-FUND' => "Fundamentals",
            '2-BLHD' => "Blood & Host Defense",
            '3-SBM'  => "Skin, Bones & Musculature",
            "4-CPR"  => "Cardiopulmonary & Renal",
            "5-HODI" => "Hormones & Digestion",
            "6-NSF"  => "Nervous System & Function",
            "7-DEVH" => "Developing Human"

}

## Questin labels for formative feedback
LABELS = {
  "q1" => "Student Name",
  "q2" => "Facilitator Name",
  "q3" => "Please comment on any kudos you have for this student.",
  "q4" => "Please provide any comments on areas this student needs to work on.",
  "q5" => "Chief concern noted either before HPI or as part of introductory sentence, framed by the patient's most pertinent history.",
  "q6" => "The HPI starts with a clear patient introduction including patient's age, sex, and the chief complaint. The chief complaint is framed by their pertinent active medical problems, the reason for seeking care, and includes the time course.",
  "q7" => "Presents a focused physical exam. Begins with vitals, general appearance, and pertinent PE findings (no need to include non-pertinent normal findings).",
  "q8" => "H&P proposes either a diagnostic or therapeutic plan."
}
#-------------------------------------------------------------------------
# qualtric Question  --- Database # Question/fieldname
#   Q11                   Q3
#   Q12                   Q4
#   Q3                    Q5
#   Q13                   Q6
#-------------------------------------------------------------------------
LABELS2 = {
  "q1" => "Student Name",
  "q2" => "Facilitator Name",
  "q3" => "History Taking Skills - please provide positive feedback and constructive suggestions for improvement.",
  "q4" => "Examination Skills - please provide positive feedback and constructive suggestions for improvement.",
  "q5" => "Discussion skills - please provide positive feedback and constructive suggestions for improvement.",
  "q6" => "Additional comments or suggestions for this student (optional)",
  "q7" => "",
  "q8" => ""
}

LABELS3 = {
  "q1" => "Student Name",
  "q2" => "Facilitator Name",
  "q3" => "",
  "q4" => "",
  "q5" => "",
  "q6" => "",
  "q7" => "Informatics Formative Feedback",
  "q8" => "Attachment File"
}

def get_label (permission_group_id, course_code, component)
  label = FomLabel.find_by(permission_group_id: permission_group_id, course_code: course_code).labels
  label = JSON.parse(label)
  labels = label.first.select{|key, val| val if key.include? component and !key.include? "avg"}
  weights = {}
  labels.each_with_index do |(key, value), index|
      weights[key]  = value.scan(/\((.*?)\)/).first.first.gsub("%", "").to_f/100.00
  end
  return weights
end

def get_label2(permission_group_id, course_code, component_code)
  label = FomLabel.find_by(permission_group_id: permission_group_id, course_code: course_code).labels
  label = JSON.parse(label)
  labels = label.first.select{|key, val| val if key.include? component_code and !key.include? "dropped" and !key.include? "summary" }
  return labels.keys
end

def compute_weighted_avg(fom_exams, filter_key, sub_component, avg_weights, score, user)
  comp = fom_exams.map(&:attributes).first.select{|key, val| val if key.include? filter_key}
  weighted_avg = 0.0
  comp[sub_component] = score
  avg_weights.each_with_index do |(key, value)|
      weighted_avg += (comp[key].to_f/100*value)*100
  end
  return weighted_avg.truncate(2)
end

def compute_average (fom_exams, component, comp1_fields, sub_comp_data, user)
  if fom_exams.empty?
    comp1_array = FomExam.column_names
    comp1_array = comp1_array.select{|c| c if c.include? component and !c.include? "summary"}
    comp1 = {}
    comp1_array.each do |comp|
      comp1[comp] = 0.0
    end
  else
    comp1 = fom_exams.map(&:attributes).first.select{|key, val| val if key.include? component and !key.include? "summary"}
  end
  average = 0.0, total_score = 0.0
  comp1_fields.each do |field|
    total_score += comp1[field].nil? ? 0.0 : comp1[field]
  end
  average = (total_score + sub_comp_data)/comp1_fields.count.to_d
  return average.truncate(2)
end

def process_tab_sheet(permission_group_id, course_code, component, sub_component, sheet)
  last_row = sheet.count-1
  #permission_group_id = 20
  #course_code = '5-HODI'
  row = {}
  header = sheet[0]
  for r in 1..last_row do
    row = Hash[[header, sheet[r]].transpose]
    row_hash = {}
    if !row["sid"].to_s.include? "U00" and row["sid"].to_s != ""
      formatted_sid = format('U%08d', row["sid"])
    else
      return
    end

    user = User.find_by(sid: formatted_sid)
    if !user.nil?
      row_hash["permission_group_id"] = user.permission_group_id
      row_hash["course_code"] = course_code
      row_hash["submit_date"] = Time.now.strftime("%Y/%m/%d") # this need to be changed
      row_hash["user_id"] = user.id

      ### compute weighted average
      fom_exams = FomExam.where(user_id: user.id, course_code: row_hash["course_code"], permission_group_id: row_hash["permission_group_id"])

      if !fom_exams.empty?
        case component
          when 'comp1'
            row_hash[sub_component] = row["score"]
            comp1_fields = get_label2(permission_group_id, course_code, 'comp1')
            row_hash["summary_comp1"] = compute_average(fom_exams, component, comp1_fields, row_hash[sub_component], user)
          when 'comp2a'
            row_hash[sub_component] = row["score"]
            avg_weights = get_label(permission_group_id, course_code, 'comp2a_hss')
            row_hash["comp2a_hssavg"] = compute_weighted_avg(fom_exams, 'comp2a_hss', sub_component, avg_weights, row_hash[sub_component], user)
            row_hash["summary_comp2a"] = row_hash["comp2a_hssavg"]
          when 'comp2b'
            row_hash[sub_component] = row["score"]
            avg_weights = get_label(permission_group_id, course_code, 'comp2b_bss')
            row_hash["comp2b_bssavg"] = compute_weighted_avg(fom_exams, 'comp2b_bss', sub_component, avg_weights, row_hash[sub_component], user)
            row_hash["summary_comp2b"] = row_hash["comp2b_bssavg"]
          when 'comp3'
            row_hash[sub_component] = row["score"]
            avg_weights = get_label(permission_group_id, course_code, 'comp3')
            row_hash["summary_comp3"] = compute_weighted_avg(fom_exams, 'comp3', sub_component, avg_weights, row_hash[sub_component], user)

          when 'comp4'
            row_hash[sub_component] = row["score"]
            row_hash["summary_comp4"] = row_hash[sub_component]
          when 'comp5a'
            row_hash[sub_component] = row["score"]
            avg_weights = get_label(permission_group_id, course_code, 'comp5a_hss')
            row_hash["comp5a_hssavg"] = compute_weighted_avg(fom_exams, 'comp5a_hss', sub_component, avg_weights, row_hash[sub_component], user)
            row_hash["summary_comp5a"] = row_hash["comp5a_hssavg"]
          when 'comp5b'
            row_hash[sub_component] = row["score"]
            avg_weights = get_label(permission_group_id, course_code, 'comp5b_bss')
            row_hash["comp5b_bssavg"] = compute_weighted_avg(fom_exams, 'comp5b_bss', sub_component, avg_weights, row_hash[sub_component], user)
            row_hash["summary_comp5b"] = row_hash["comp5b_bssavg"]
        else
          @log_date.push ("*** Invalid Component: " + component)
        end

        FomExam.where(user_id: user.id, course_code: row_hash["course_code"], permission_group_id: row_hash["permission_group_id"]).first_or_create.update(row_hash)
        @log_data.push ("Updated student with score -->  " + row["lastname"] + ", " + row["firstname"] + " #{sub_component} = " + row["score"].to_s)
      else
        # first time insertion
        if component == 'comp1'
          fom_exams = []
          row_hash[sub_component] = row["score"]
          comp1_fields = get_label2(permission_group_id, course_code, 'comp1')
          row_hash["summary_comp1"] = compute_average(fom_exams, component, comp1_fields, row_hash[sub_component], user)
          FomExam.where(user_id: user.id, course_code: row_hash["course_code"], permission_group_id: row_hash["permission_group_id"]).first_or_create.update(row_hash)
          @log_data.push ("Updated student with score -->  " + row["lastname"] + ", " + row["firstname"] + " = " + row["score"].to_s )
          #puts "Updated student with score -->  " + row["lastname"] + ", " + row["firstname"] + " #{sub_component} = " + row["score"].to_s
        else
          @log_data.push ("** THIS STUDENT IS NOT UPDATED -->  " + row["lastname"] + ", " + row["firstname"] + " = " + row["score"].to_s ) + "  #{component} --> #{sub_component}"
        end
      end

    else
      @log_data.push ("User NOT found in Users Table -->  " + row["sid"] + " " + row["lastname"] + ", " + row["firstname"])
    end

  end
end

  def hf_fom_process_file(artifact)
    @log_data = []
    file_name = ActiveStorage::Attachment.find(artifact.documents.first.id).blob.filename.to_s
    file_name = File.basename(file_name, File.extname(file_name)) ## without file extension

    xlsx = Xsv::Workbook.open(ActiveStorage::Attachment.find(artifact.documents.first.id).blob.download)
    permission_group_id, course_code, component = artifact.title.split("/")
    sub_component = artifact.content

    file_name = permission_group_id + "_" + course_code + "_" + sub_component

    xlsx.sheets.each do |sheet|
    	if sheet.name != 'Upload'
    		@log_data.push ("Sheet Name: " + sheet.name)
    		@log_data.push ("No of rows: " + sheet.count.to_s)
    		process_tab_sheet(permission_group_id, course_code, component, sub_component, sheet)
    		@log_data.push ("===================================")
    	end
    end
    xlsx.close
    # todayDate = Time.now.strftime("%Y_%m_%d")
    directory_name = "#{Rails.root}/log/fom_exams"
    Dir.mkdir(directory_name) unless File.exist?(directory_name)

    file_name = "#{Rails.root}/log/fom_exams/#{file_name}.log"
    File.open(file_name, 'w') {
      |f| @log_data.each { |line| f << "\r\n" + line }
    }
    return @log_data
  end

  def hf_load_label_file(artifact)
    @log_data = []

    # file_name = ActiveStorage::Attachment.find(artifact.documents.first.id).blob.filename.to_s
    # file_name = File.basename(file_name, File.extname(file_name)) ## without file extension

    xlsx = Xsv::Workbook.open(ActiveStorage::Attachment.find(artifact.documents.first.id).blob.download)
    permission_group_id, course_code, component = artifact.title.split("/")
    xlsx.sheets.each do |sheet|
      last_row = sheet.count-1
      temp_hash = {}
  		for r in 0..last_row do
        row = sheet[r]
        if row.compact.empty?  # if array is empty
          break
        else
          temp_hash[row[0]] = row[1]
          @log_data.push "row #{r.to_s}= " + row[0].to_s + " --> " + row[1].to_s
        end
      end
      temp_array = []
      temp_array.push temp_hash
      json_string = temp_array.to_json ## json string mus t be in an array
      row_hash = {}
      row_hash["permission_group_id"] = permission_group_id
      row_hash["course_code"] = temp_array.first["course_code"]
      row_hash["labels"] = json_string

      FomLabel.where(permission_group_id: permission_group_id, course_code: course_code).first_or_create.update(row_hash)
    	@log_data.push ("===================================")

    end
    xlsx.close

    directory_name = "#{Rails.root}/log/fom_exams"
    Dir.mkdir(directory_name) unless File.exist?(directory_name)

    cohort_title = PermissionGroup.find(permission_group_id).title.split("(").last.gsub(")", "")
    file_name = cohort_title + "_" + course_code + "_" + component

    file_name = "#{Rails.root}/log/fom_exams/#{file_name}.log"
    File.open(file_name, 'w') {
      |f| @log_data.each { |line| f << "\r\n" + line }
    }

  end

  def encrypt_data (crypt, in_data)
    #crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base[0..31], Rails.application.secrets.secret_key_base)
    encrypted_data = crypt.encrypt_and_sign(in_data)
  end

  def decrypt_data (crypt, encrypted_data)
    #crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base[0..31], Rails.application.secrets.secret_key_base)
    decrypted_back = crypt.decrypt_and_verify(encrypted_data)
  end

  def hf_reformat_cohort_data(cohorts)
    temp_cohort = {}
    cohorts.each do |cohort|
      cohort_id = cohort.values.first
      cohort_title = cohort.values.second.split(' ').last.gsub(/[()]/, '')
      temp_cohort.store(cohort_id, cohort_title)
    end
    return temp_cohort

  end

  def hf_get_block_desc(in_code)
    return BLOCKS[in_code]
  end

  def hf_component_desc(in_code)
    if !COMPONENT_DESC[in_code].nil?
      return COMPONENT_DESC[in_code]
    end
  end

  def hf_component_desc2(in_code)
    if !COMPONENT_DESC_MED21[in_code].nil?
      return COMPONENT_DESC_MED21[in_code]
    end
  end

  def hf_formative_feedback_labels(in_q, label_code)
    if label_code == '_qs1'
      label = LABELS[in_q]
    elsif label_code == '_qs2'
      label = LABELS2[in_q]
    elsif label_code == '_qs3'
      label = LABELS3[in_q]
    else
      return in_q
    end

     if label.nil?
       return in_q
     else
       return label
     end
  end

  def hf_check_failed_comp(comp, failed_comps, coaching_type)

    str_warning = ""
    return str_warning if coaching_type == "student"
    failed_comps.each do |fcomp|
      if fcomp.include? comp
        return '<div class="fa fa-exclamation-triangle" style="color:red"> </div>'
      end
    end
    return str_warning
  end

  def hf_scan_failed_score(hash_components)
    failed_comp = []
    comp_keys = FomExam.comp_keys
    hash_components.each do |comp|
      comp_keys.each do |comp_key|
        value = comp.map{|key, value| value if key.include? comp_key and value.to_d < 70.00}.compact
        if !value.empty?
          failed_comp.push comp_key
        end
      end
    end
    return failed_comp
  end

  def check_pass_fail(data_series)
    fail_hash = {}
    new_series = []
    data_series.each do |score|
      if (score < 70 and score != 0.0)
        fail_hash = {y: score, color: "#FF6D5A"}
        new_series.push fail_hash
      elsif score == 0.0
        fail_hash = {y: nil}
        new_series.push fail_hash
      else
        new_series.push score
      end
    end
    return new_series
  end

  def hf_check_label_file(attachment_id)
    filename = ActiveStorage::Attachment.find(attachment_id).filename.to_s
    if filename.downcase.include? 'label'
      csv_table = CSV.parse(ActiveStorage::Attachment.find(attachment_id).download, headers: true, col_sep: "\t")
      json_string = csv_table.map(&:to_h).to_json
      label_hash = JSON.parse(json_string)
      permission_group_id = label_hash.first["permission_group_id"]
      course_code = label_hash.first["course_code"]
      if !course_code.blank?
        FomLabel.where(permission_group_id: permission_group_id, course_code: course_code).first_or_create.update(labels: json_string)
        return true
      end
    else
      return false
    end
  end

  def hf_export_fom_block permission_group_id, course_code
    fom_label = FomLabel.where(permission_group_id: permission_group_id, course_code: course_code).first
    row_to_hash = JSON.parse(fom_label.labels).first  # fom_label.labels is a json object
    sql = "select users.full_name, "
    row_to_hash.each do |fieldname, val|  # build sql using form label record --> customized headers
      if fieldname != 'permission_group_id' and !val.nil?
        val = val.gsub(" ", "")
        sql += fieldname + ', '  #"#{key}, "
      end
    end
    sql = sql.delete_suffix(", ")
    results = FomExam.execute_sql(sql + " from fom_exams, users where users.id = fom_exams.user_id  and fom_exams.course_code = " + "'#{course_code}'" +
              " and fom_exams.permission_group_id=" + "#{permission_group_id} " + " order by users.full_name ASC").to_a

    return results
  end

  def hf_create_graph(component, class_data, avg_data, categories, permission_group)

    student_name = class_data.first["full_name"]  # processing student Alver
    student_series = class_data.first.drop(2)  # removed the first 2 items in array
    student_series = student_series.map{|d| d.second.to_s.to_f if d.first.include? component}.compact
    class_mean_series = avg_data.first.map{|s| s.second.to_s.to_d.truncate(2).to_f if s.first.include? component}.compact
    selected_categories = categories.map {|key, val| val if key.include? component}.compact

    if permission_group >= 20 and component == 'comp1_wk'
      count = selected_categories.count
      for i in 0..count-1
        #if student_series[i].instance_of?(Hash)
          if (class_mean_series[i] != 0.0) and (student_series[i] == 0.0)
            selected_categories[i] += "<br/><span style='color:red'>Missed Assessment (remediation required)</span>"
            @missing_weekly = true
          end
        #end
      end
    end

    if permission_group >= 20 and component == 'comp2a_hss'
      count = selected_categories.count
      for i in 0..count-1
        if (selected_categories[i].include? "EHR" or selected_categories[i].downcase.include? "pre-lab" or selected_categories[i].downcase.include? "informatics" or
          selected_categories[i].downcase.include? "active learning" )
          if class_mean_series[i] != 0.00  and student_series[i] == 0.0
            selected_categories[i] += "<br/><span style='color:red'>Missed Assessment (remediation required)</span>"
            @missing_pre_lab = true
          # elsif (categories["course_code"] == '4-CPR' or categories["course_code"] == '5-HODI') and student_series[i] == 0.0
          #   selected_categories[i] += "<br/><span style='color:red'>Missed Assessment (remediation required)</span>"
          #   @missing_pre_lab = true
          end
        end

      end
    end

    if (component.include? 'summary' and @missing_weekly)
      selected_categories[0] += "<br/><span style='color:red'>Missed Assessment (remediation required)</span>"
    end

    if (component.include? 'summary' and @missing_pre_lab)
      # if (categories["course_code"] == '6-NSF') and !student_series[1].is_a?(Float) and (student_series[1][:y] <= 75.0)
      #     selected_categories[1] += "<br/><span style='color:red'>Missed Assessment (remediation required)</span>"
      # end
      selected_categories[1] += "<br/><span style='color:red'>Missed Assessment (remediation required)</span>"
    end

    student_series = check_pass_fail(student_series)
    class_mean_series = check_pass_fail(class_mean_series)

    height = 400

    if component == 'comp1_wk' and permission_group >= 20
      title =  hf_component_desc(component) + '<br ><span style="color:red">Formative Feedback</span>' + '<br ><b>' + student_name + '</b>'
    else
      title =  hf_component_desc(component) + '<br ><b>' + student_name + '</b>'
    end

    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: title)
      #f.subtitle(text: '<br /><h4>Student: <b>' + student_name + '</h4></b>')
      f.xAxis(categories: selected_categories,
        labels: {
              style:  {
                          fontWeight: 'bold',
                          color: '#000000',
                          fontSize: '13px'
                      }
                }
      )
      f.series(name: "Student", yAxis: 0, data: student_series)
      f.series(name: "Class Mean", yAxis: 0, data: class_mean_series)

      # ["#FA6735", "#3F0E82", "#1DA877", "#EF4E49"]
      f.colors(["#7EFF5E", "#6E92FF"])
      f.yAxis [
         { tickInterval: 20,
           title: {text: "Score (%)", margin: 20,
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

end
