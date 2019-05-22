class EpaReview < ApplicationRecord
  belongs_to :reviewable, polymorphic: true

  def self.format_reviewer(reviewer)
    temp_name = reviewer.split(" ")
    return temp_name.last + ", " + temp_name.first
  end

  def self.check_for_auto_badging user_id
    byebug
    epa_masters = EpaMaster.where(user_id: user_id).order(:epa)
    epa_masters.each do |epa_master|
      epa_reviews_badge_cnt = EpaReview.where(epa: epa_master.epa, reviewable_id: epa_master.id, egm_recommendation: 'Badge' ).count
      if epa_reviews_badge_cnt >= 2
        epa_master.update(status: 'Badge', status_date: Time.now, expiration_date: DateTime.now.next_year(3).to_time)
      end
    end
  end

  def self.create_epa_reviews(epa_reviews, user_id)
    epa_reviews.each do |review|
        epa = review["Q3"].split(":").first.gsub(" ", "")
        reviewable_id = EpaMaster.select(:id).find_by(user_id: user_id, epa: epa).id
        response_id = review["ResponseID"]
        EpaReview.where(response_id: response_id).first_or_create do |rev|
          rev.epa = review["Q3"].split(":").first.gsub(" ", "")
          rev.review_date1 = review["StartDate"]
          rev.reviewed_by1 = format_reviewer(review["Q2"])
          rev.egm_recommendation = review["Q13"]
          rev.badge = review["Q14"]
          rev.insufficient_evidence = review["Q16"]
          rev.deny = review["Q16"]
          rev.general_comments = review["Q12"]
          rev.response_id = response_id
          rev.reviewable_id = reviewable_id
          rev.reviewable_type = "EpaMaster"
        end
    end
  end

  def self.api_qualtrics(username, user_id)
     system("python #{Rails.root}/public/epa_reviews/python_qualtrics_api.py")
     get_qualtrics_msg = []

     get_qualtrics_msg.push "Downloaded Qualtrics Responses.."

     json ||= File.read("#{Rails.root}/public/epa_reviews/epa_download.json")
     epa_reviews_hash = JSON.parse(json).values.flatten
     get_qualtrics_msg.push "Read JSON objects from file..."
     epa_reviews = epa_reviews_hash.select {|r| r['Q1'].include? username }

     if epa_reviews.nil?
        get_qualtrics_msg.push "Not able to locate student review..."
     else
        get_qualtrics_msg.push "Found student review..."
        create_epa_reviews(epa_reviews, user_id)
        check_for_auto_badging(user_id)
        get_qualtrics_msg.push "EPA reviews are created..."
     end
     return get_qualtrics_msg
  end

end
