module EpaMastersHelper

  def hf_student_groups
    student_groups ||=  PermissionGroup.select(:id, :title).where("title Like ?", "%Students%").order(:title)
    return student_groups
  end

  def create_epa_masters (selected_user_id)
    for i in 1..13 do
      EpaMaster.where(user_id: selected_user_id, epa: "EPA#{i}").first_or_create do |epa|
        epa.user_id = selected_user_id
        epa.epa = "EPA#{i}"
      end
    end
  end

  def get_epa_reviews(epa_master)
    reviews = epa_master.epa_reviews
    status_str = ""
    reviews.each do |review|
      status_str = review.egm_recommendation + "|" + hf_format_date(review.review_date1) + "|" + review.general_comments
    end
    return status_str
  end

  def hf_get_epa_master_badges(selected_user_id)
    epa_badges = []
    status_date_array = []
    badged = {}
    status_date = {}
    selected_recs = EpaMaster.where(user_id: selected_user_id).order(:id).includes(:epa_reviews)

    if selected_recs.length < 13
      create_epa_masters (selected_user_id)
      selected_recs = EpaMaster.where(user_id: selected_user_id).order(:id)
    end
    selected_recs.each do |rec|
      badged = {rec.epa => "epa/#{rec.epa}.png"}
      if (rec.status == "Badge")
        status_date = {rec.epa => hf_format_date(rec.status_date)}

      else
        status_date = {rec.epa => get_epa_reviews(rec)}

        #badged = {rec.epa => "epa/not_badge_#{rec.epa}.png"}
      end
      status_date_array.push status_date
      epa_badges.push badged
    end

    return epa_badges, status_date_array
  end

  def hf_format_date (in_date)
    if !in_date.nil?
      in_date = in_date.strftime("%m/%d/%Y")
    else
      return ""
    end
  end

  def hf_count_not_badged (in_hash)
    return in_hash.select{|k| k.first.second.include? "not" }.count
  end

  def hf_get_entrustment_members
    json ||= File.read("#{Rails.root}/public/entrustment_members.json")
    entrustment_members = JSON.parse(json).values.flatten.sort
    return entrustment_members
  end
end
