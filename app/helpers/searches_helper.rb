module SearchesHelper

  def median(ary)
    middle = ary.size/2
    sorted = ary.sort_by{ |a| a }
    ary.size.odd? ? sorted[middle] : (sorted[middle]+sorted[middle-1])/2.0
  end

  def get_stats (permission_group_id)
    result = ActiveRecord::Base.connection.exec_query('select count(user_id)
              from epas, users
              where involvement <> 0 and
                   users.id = epas.user_id and
                   users.permission_group_id = ' + permission_group_id.to_s + '
              group by
                user_id
              order by count DESC')

    return result
  end


  def hf_wba_stats(user)

    if user.coaching_type == 'student'
      cohort_title = user.permission_group.title[/(?<=\().*?(?=\))/]  # to extract cohort Med21
      permission_group_id = user.permission_group_id
      result = get_stats(permission_group_id)
      arr = result.rows.flatten  # the array is sorted DESC
      #max = arr.first
      #min = arr.last
      ave = arr.sum.fdiv(arr.size).round
      med = median(arr).round
      return ave, med, cohort_title
    elsif user.coaching_type == 'dean' or user.coaching_type == 'admin'
      cohorts = PermissionGroup.where("id >= ? and id <> 15", 13).order(:title)
      cohorts_stat = {}
      stat = []
      cohorts.each do |cohort|
        title = cohort.title[/(?<=\().*?(?=\))/]
        result = get_stats(cohort.id)
        if !result.empty?
          arr = result.rows.flatten  # the array is sorted DESC
          stat << arr.first
          stat << arr.last
          stat << arr.sum.fdiv(arr.size).round
          stat << median(arr).round
          cohorts_stat.store(title, stat)
        end
        stat = []

      end

      return cohorts_stat

    end

  end

  def hf_releaseDate(user)
    @badge_release_date ||= YAML.load_file("config/badgeReleaseDate.yml")

    if user.permission_group_id = 13
      return @badge_release_date["Med21Badge"]["releaseDate"]
    elsif user.permission_group_id = 16
      return @badge_release_date["Med22Badge"]["releaseDate"]
    elsif user.permission_group_id = 17
      return @badge_release_date["Med23Badge"]["releaseDate"]
    elsif user.permission_group_id = 18
      return @badge_release_date["Med24Badge"]["releaseDate"]
    elsif user.permission_group_id = 19
      return @badge_release_date["Med25Badge"]["releaseDate"]
    else

   end
  end

  def hf_exists_in_FomExam(user_id)
    block_array = []
    blocks = FomExam.where(user_id: user_id).select(:course_code, :permission_group_id).order('course_code ASC').uniq
    blocks.each do |block|
      block_hash = {}
      if current_user.dean_or_higher?
        block_hash.store("course_code", block.course_code)
      elsif FomLabel.find_by(permission_group_id: block.permission_group_id, course_code: block.course_code).block_enabled
          block_hash.store("course_code", block.course_code)
      else
          block_hash.store("course_code", block.course_code + " - DISABLED!")
      end
      cohort = PermissionGroup.find(block.permission_group_id).title.delete('()').split(" ").last

      block_hash.store("permission_group_id", block.permission_group_id)
      block_hash.store("cohort", cohort)
      block_array.push block_hash
    end
    return block_array
  end

  def hf_exists_in_PreceptorEval(user_id)
    preceptor_evals = PreceptorEval.where(user_id: user_id).select(:user_id, :permission_group_id).uniq.first
    return nil if preceptor_evals.nil?
    cohort = PermissionGroup.find(preceptor_evals.permission_group_id).title.delete('()').split(" ").last
    return cohort
  end

  def probe_dataset(lime_survey)
    student_data = []
    student_email_col = lime_survey.student_email_column
    #comp_data = lime_survey.lime_groups.first.lime_questions.first.dataset
    comp_data = lime_survey.dataset
    student_data = comp_data.select {|rec| rec["#{student_email_col}"] == @pk}
    return student_data
  end

  def get_csl_data (in_array)
    temp_array = []
    in_array.each do |data|
      if data.include? "CSL Narrative"
        temp_array.push data
      end
    end
    return temp_array
  end

  def hf_read_tempfile
     if File.file? (Rails.root + "tmp/#{current_user.login}_search.json")
       json_obj = File.read(Rails.root + "tmp/#{current_user.login}_search.json")
       survey_array = JSON.parse(json_obj)
     else
        return nil
     end
  end

  def hf_write_hash(in_hash)
    file_ptr = File.open(Rails.root + "tmp/#{current_user.login}_search.json", 'w')
    file_ptr.write(in_hash.to_json)
    file_ptr.close

  end

  def create_hash (survey_array, username, temp_hash)
      survey_json = []
      user_json = {}
      survey_array.each do |s|
         s_json = {
           "sid" => s.split("~").first,
           "survey" => s.split("~").last
         }
         survey_json << s_json
      end
      temp_hash["#{username}"] = survey_json
      return temp_hash
  end

  def hf_datasets (result, temp_hash)
    survey_array = []
    if result.coaching_type == 'student'

      surveygrps = PermissionLsGroup.where(permission_group_id: result.permission_group_id).order(:updated_at) #result.permission_group.permission_ls_groups
      #surveygrps = surveygrps.sort_by(&:updated_at)
      if !result.prev_permission_group_id.nil?
        prev_surveygrps = PermissionLsGroup.where(permission_group_id: result.prev_permission_group_id).order(:updated_at)
        surveygrps = (surveygrps + prev_surveygrps)
      end

      surveygrps.each do |s|
        survey = s.lime_survey.title
        sid = s.lime_survey.sid
        if current_user.superadmin? and !probe_dataset(s.lime_survey).empty?
          survey_array.push sid.to_s + "~" + survey
        #elsif survey.include? "Graph View" or survey.include? "Remediation" or survey.include? "Core Clinical/Electives"

        else
          if !probe_dataset(s.lime_survey).empty?
              survey_array.push sid.to_s + "~" + survey
           end
        end
      end
      #store surveys in session variable
      session[:search] ||= []
      session[:search] = nil
      session[:search] = get_csl_data(survey_array)

      survey_array = survey_array.uniq

      temp_hash = create_hash(survey_array, result.login, temp_hash)


      return survey_array
     else
      return ["Not Applicable"]
     end
  end

  def hf_graph_type (dataset)
    if dataset.include? "Core Clinical" or dataset.include? "Remediation"
      return "spreadsheet"
    else
      return "graph"
    end
  end

  def hf_dataset_sid in_param
     in_param.gsub!('*', '')
      clinical_survey = LimeSurveysLanguagesetting.where("lower(surveyls_title) LIKE :in_param",
        in_param: 'sa:' + in_param.downcase + ':clinical phase:core clinical%')
      return clinical_survey.first.surveyls_survey_id

  end

  def hf_student_year(in_code)
    return "20" + in_code.downcase.split('med').second
  end

  def hf_competency_exists(user_id)
    comp = Competency.find_by(user_id: user_id)
    if comp.nil?
        return false
    else
      return true
    end
  end

end
