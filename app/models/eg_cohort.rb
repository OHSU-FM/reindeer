class EgCohort < ApplicationRecord
  belongs_to :user

  def self.get_all_eg_cohorts(permission_group_id)
    results = EpaMaster.execute_sql("select permission_groups.title as cohort, users.full_name,
        eg_cohorts.email, eg_full_name1, eg_email1, eg_full_name2, eg_email2, eg_cohorts.created_at, eg_cohorts.updated_at
        from eg_cohorts, users, permission_groups
        where eg_cohorts.email = users.email and
        eg_cohorts.permission_group_id = permission_groups.id and
        eg_cohorts.permission_group_id = ? order by users.full_name", permission_group_id.to_i).to_a

    return results

  end
end
