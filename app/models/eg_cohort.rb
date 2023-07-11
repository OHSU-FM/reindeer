class EgCohort < ApplicationRecord
  belongs_to :user



  rails_admin do

    list do
      exclude_fields :created_at
    end

    create do

      field :permission_group_id, :enum do
        enum do
          PermissionGroup.where('title like ?', "%Student%").order(:id).collect {|p| [p.title, p.id]}
        end
      end

      field :user_id, :enum do
        enum do
          User.where("spec_program not like '%Graduated%' and
                      spec_program not like '%LOA%' and
                      spec_program not like '%Dismiss%' and
                      spec_program not like '%Withdrawn%' and
                      spec_program not like '%Withdrawal%' and
                      spec_program not like '%withdrew%'").order(:full_name).collect {|p| [p.full_name, p.id]}
        end
      end
      field :email, :enum do
        enum do
          User.where("spec_program not like '%Graduated%' and
                      spec_program not like '%LOA%' and
                      spec_program not like '%Dismiss%' and
                      spec_program not like '%Withdrawn%' and
                      spec_program not like '%Withdrawal%' and
                      spec_program not like '%withdrew%'").order(:full_name).collect {|p| [p.full_name, p.email]}
        end
      end
      field :eg_full_name1, :enum do
          enum do
            EgCohort.get_eg_members
          end
      end

      field :eg_email1, :enum do
          enum do
            EgCohort.get_eg_emails
          end
      end
      field :eg_full_name2, :enum do
          enum do
            EgCohort.get_eg_members
          end
      end
      field :eg_email2, :enum do
          enum do
            EgCohort.get_eg_emails
          end
      end
    end
  end

  def self.get_eg_emails
    eg1 = EgCohort.all.pluck(:eg_email1).uniq.sort
    eg2 = EgCohort.all.pluck(:eg_email2).uniq.sort
    return (eg1+eg2).uniq.sort
  end

  def self.get_eg_members
    eg1 = EgCohort.all.pluck(:eg_full_name1).uniq.sort
    eg2 = EgCohort.all.pluck(:eg_full_name2).uniq.sort
    return (eg1+eg2).uniq.sort
  end

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
