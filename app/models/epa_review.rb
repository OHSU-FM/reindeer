class EpaReview < ApplicationRecord
  belongs_to :reviewable, polymorphic: true

  def self.format_reviewer(reviewer)
    temp_name = reviewer.split(" ")
    return temp_name.last + ", " + temp_name.first
  end

  def self.update_epa_master(reviewable_id, epa, egm_recommendation)

    if egm_recommendation == "Badge"
      EpaMaster.where(id: reviewable_id, epa: epa).update(status: 'Badge', status_date: Time.now, expiration_date: DateTime.now.next_year(3).to_time)
    else
      EpaMaster.where(id: reviewable_id, epa: epa).update(status: nil, status_date: nil, expiration_date: nil)
    end
    return user_id = EpaMaster.where(id: reviewable_id).select(:user_id)
  end

  def self.create_epa_reviews(epa_reviews)

    dir = "#{Rails.root}/public/epa_reviews"
    File.open(File.join(dir, 'qualtrics_epa_reviews.txt'), 'w') do |f|
      epa_reviews.each do |review|
            student = review["Q1"]
            epa = review["Q3"].split(":").first.gsub(" ", "")
            review_date1 = review["StartDate"]
            reviewed_by1 = format_reviewer(review["Q2"])
            egm_recommendation = review["Q13"]
            badge = review["Q14"]
            insufficient_evidence = review["Q16"]
            deny = review["Q16"]
            general_comments = review["Q12"]
            response_id = review["ResponseID"]
            f.puts response_id + "|" + student + "|" + epa + "|" + review_date1 + "|" + reviewed_by1 + "|" + egm_recommendation + "|" +
                   badge + "|" + insufficient_evidence + "|" + deny + "|" + general_comments
      end
      f.close
    end

  end

  def self.create_log(get_qualtrics_msg)
    File.open("#{Rails.root}/public/epa_reviews/get_qualtrics.log", "w+") do |f|
      f.puts(get_qualtrics_msg)
    end

  end

  def self.api_qualtrics
     get_qualtrics_msg = []

     system("python #{Rails.root}/public/epa_reviews/python_qualtrics_api.py")
     get_qualtrics_msg.push "Launched Python script.."
     # need to rename the file to epa_download.json

     file = Dir.glob("#{Rails.root}/public/epa_reviews/Entrustment*.json")
     get_qualtrics_msg.push "Try to locate json file.."

     File.rename(file.first, "#{Rails.root}/public/epa_reviews/epa_download.json")
     get_qualtrics_msg.push "Try to rename file.."

     json ||= File.read("#{Rails.root}/public/epa_reviews/epa_download.json")
     epa_reviews_hash = JSON.parse(json).values.flatten
     get_qualtrics_msg.push "Read JSON objects from file..."
     # no filter & create text delimited file
     # epa_reviews = epa_reviews_hash.select {|r| r['Q1'].include? username }

    #user_id is not being used.
    create_epa_reviews(epa_reviews_hash)
    get_qualtrics_msg.push "EPA reviews are created..."

    create_log(get_qualtrics_msg)

     return get_qualtrics_msg
  end

end
