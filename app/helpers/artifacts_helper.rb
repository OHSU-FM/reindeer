module ArtifactsHelper

  ARTIFACT_CATEGORY = ["FoM", "Clinical", "Exemplary Professionalism", "EPA-Artifacts", "Progress Board", "Grade Dispute",
    "MSPE", "NBME", "Preceptorship Contract", "Scholarly Project", "TTR", "Preceptor Evals", "Formative Feedback", "FoM Grades", "Competency", "BLS",
    "EG Cohorts", "Other"]

  def hf_category
    return ARTIFACT_CATEGORY
  end

  def hf_filter_fom_labels(component, labels)
    case component
      when 'comp1'
        temp_labels = labels.first.map{|key, val|  [key, val= key + " = " + val.to_s] if key.include? component and !key.include? "dropped" and !key.include? "summary"}.compact
        return temp_labels
      when 'comp2a'
        temp_labels = labels.first.map{|key, val|  [key, val= key + " = " + val.to_s] if key.include? component and !key.include? "avg" and !key.include? "summary"}.compact
        return temp_labels
      when 'comp2b'
        temp_labels = labels.first.map{|key, val|  [key, val= key + " = " + val.to_s] if key.include? component and !key.include? "avg" and !key.include? "summary"}.compact
        return temp_labels
      when 'comp3'
        temp_labels = labels.first.map{|key, val|  [key, val= key + " = " + val.to_s] if key.include? component and !key.include? "summary"}.compact
        return temp_labels
      when 'comp4'
        temp_labels = labels.first.map{|key, val|  [key, val= key + " = " + val.to_s] if key.include? component and !key.include? "summary"}.compact
        return temp_labels
      when 'comp5a'
        temp_labels = labels.first.map{|key, val|  [key, val= key + " = " + val.to_s] if key.include? component and !key.include? "avg" and !key.include? "summary"}.compact
        return temp_labels
      when 'comp5b'
        temp_labels = labels.first.map{|key, val|  [key, val= key + " = " + val.to_s] if key.include? component and !key.include? "avg" and !key.include? "summary"}.compact
        return temp_labels
      else
        return 'Invalid Component - Please Stop!'
    end

  end

  def hf_check_nbme_pdf(shelf_artifacts)
    no_of_nbme = 0
    # if shelf_artifacts.first.nil?
    #   return 0
    # end
    shelf_artifacts.each do |artifact|
      artifact.documents.each do |document|
        if document.filename.to_s.include? "NBME"
          no_of_nbme += 1
        end
      end
    end
    return no_of_nbme
  end

  def hf_get_fom_artifacts (pk, artifact_title, artifact_content)
    selected_user = User.find_by(email: pk)
    if selected_user.nil?
      return nil,0, []
    else
      no_docs = 0
      artifacts_student = Artifact.where(user_id: selected_user.id, title: artifact_title).order(:id)
      fom_docs = artifacts_student.select{|a| a.content == artifact_content}
      fom_docs.each do |doc|
        no_docs = no_docs + doc.documents.count
      end
      #@shelf_artifacts = artifacts_student.select{|a| a.content == "Shelf Exams"}

      return artifacts_student, no_docs, fom_docs
    end
  end

  def hf_get_artifacts (pk, artifact_title)
    selected_user = User.find_by(email: pk)
    if selected_user.nil?
      return nil,0, nil
    else
      no_docs = 0
      if artifact_title == "Preceptorship Contract"
        official_docs = Artifact.where(user_id: selected_user.id, title: artifact_title).order(:created_at)
      else
        official_docs = Artifact.where("user_id=? and title in ('Exemplary Professionalism','Progress Board', 'Other', 'MSPE', 'TTR', 'Grade Dispute')", selected_user.id).order(:created_at)
      end

      #official_docs = artifacts_student.select{|a| a.title == "Progress Board" or a.title == "Grade Dispute" or a.title = "MSPE" or  a.title == "Other"}
      official_docs.each do |doc|
        no_docs = no_docs + doc.documents.count
      end
      shelf_artifacts = Artifact.where(user_id: selected_user.id, content: "Shelf Exams").or(Artifact.where(user_id: selected_user.id, content: "HSS"))#artifacts_student.select{|a| a.content == "Shelf Exams"}

      return official_docs, no_docs, shelf_artifacts
    end
  end

  def hf_get_mock(user_id, artifact_title)
    # selected_user = User.find_by(email: pk)
    # if selected_user.nil?
    #   return nil
    # else
      mock_or_cpx_artifacts = Artifact.where(user_id: user_id, content: artifact_title) #artifacts_student.select{|a| a.content == "Shelf Exams"}
      return mock_or_cpx_artifacts
    # end

  end

  def hf_file_visible(code)
    if ["dean", "admin"].include?  current_user.coaching_type
      return true
    end

     record_found = FileuploadSetting.find_by(permission_group_id: current_user.permission_group_id, code: code)
     if (!record_found.nil?) and (record_found.visible)
       return true
     else
       return false
     end

 end


end
