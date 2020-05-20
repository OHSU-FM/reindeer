class EpaMaster < ApplicationRecord
  belongs_to :user, inverse_of: :epa_masters
  has_many   :epa_reviews, as: :reviewable,  dependent: :destroy
  accepts_nested_attributes_for :epa_reviews

  def badged?
     if (self.status == "Badge")
       return true
     else
       return false
     end
  end

  def self.get_epa_masters
    sql = "select em.id, em.user_id, users.full_name, em.epa, em.status, em.status_date " +
          "from epa_masters em, users " +
          "where users.id = em.user_id order by users.full_name, em.epa ASC"

    results = ActiveRecord::Base.connection.exec_query(sql)
    return results
  end



end
