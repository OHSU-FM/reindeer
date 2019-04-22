class EpaReview < ApplicationRecord
  belongs_to :reviewable, polymorphic: true

  def self.create_epa_reviews(epa_review, user_id)
    epa = epa_review.first["Q3"].split(":").first.gsub(" ", "")
    reviewable_id = EpaMaster.select(:id).find_by(user_id: user_id, epa: epa).id
    response_id = epa_review.first["ResponseID"]
    EpaReview.where(response_id: response_id).first_or_create do |rev|
      rev.epa = epa_review.first["Q3"].split(":").first.gsub(" ", "")
      rev.review_date1 = epa_review.first["StartDate"]
      rev.reviewed_by1 = epa_review.first["Q2"]
      rev.egm_recommendation = epa_review.first["Q13"]
      rev.badge = epa_review.first["Q14"]
      rev.insufficient_evidence = epa_review.first["Q16"]
      rev.deny = epa_review.first["Q16"]
      rev.general_comments = epa_review.first["Q12"]
      rev.response_id = response_id
      rev.reviewable_id = reviewable_id
      rev.reviewable_type = "EpaMaster"
    end
  end

  def self.get_qualtrics(username, user_id)
     get_qualtrics_msg = []
     json ||= File.read("#{Rails.root}/public/epa_reviews/epa_download.json")
     epa_reviews_hash = JSON.parse(json).values.flatten
     get_qualtrics_msg.push "Read JSON objects from file..."
     epa_review = epa_reviews_hash.select {|r| r['Q1'].include? username }
     if epa_review.nil?
        get_qualtrics_msg.push "Not able to locate student review..."
     else
        get_qualtrics_msg.push "Found student review..."
        create_epa_reviews(epa_review, user_id)
        get_qualtrics_msg.push "EPA reviews are created..."
     end
     return get_qualtrics_msg
  end

end
