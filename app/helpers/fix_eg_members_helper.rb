module FixEgMembersHelper

  def hf_load_eg_cohorts2
    eg_cohorts = User.joins("inner join eg_cohorts on users.email = eg_cohorts.email").
    select(:full_name, :permission_group_id, :email, :eg_full_name1, :eg_email1, :eg_full_name2, :eg_email2, :user_id).map(&:attributes)
    return eg_cohorts
  end

  def hf_update_reviewers(epa_master, reviewer1, reviewer2)
    epa_master.each do |master|
      master.epa_reviews.each do |review|
        review.update(reviewer1: reviewer1, reviewer2: reviewer2)
      end 
    end
  end

end
