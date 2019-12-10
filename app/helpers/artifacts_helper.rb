module ArtifactsHelper

  ARTIFACT_CATEGORY = ["FoM", "Clinical", "EPA-Artifacts", "Scholarly Project", "Progress Board", "Grade Dispute", "MSPE", "Preceptorship Contract", "Other"]

  def hf_category
    return ARTIFACT_CATEGORY
  end

  def hf_get_fom_artifacts (pk, artifact_title, artifact_content)
    selected_user = User.find_by(email: pk)
    if selected_user.nil?
      return nil,0
    else
      no_docs = 0
      artifacts_student = Artifact.where(user_id: selected_user.id)
      fom_docs = artifacts_student.select{|a| a.title == artifact_title and a.content == artifact_content}
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
      official_docs = Artifact.where(user_id: selected_user.id, title: ["Progress Board", "Other", "MPSE", "Grade Dispute"])
      #official_docs = artifacts_student.select{|a| a.title == "Progress Board" or a.title == "Grade Dispute" or a.title = "MSPE" or  a.title == "Other"}
      official_docs.each do |doc|
        no_docs = no_docs + doc.documents.count
      end
      shelf_artifacts = Artifact.where(user_id: selected_user.id, content: "Shelf Exams") #artifacts_student.select{|a| a.content == "Shelf Exams"}

      return official_docs, no_docs, shelf_artifacts
    end
  end

end
