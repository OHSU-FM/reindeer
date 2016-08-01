class PermissionGroup < ActiveRecord::Base
  has_many :users, :inverse_of=>:permission_group
  has_many :permission_ls_groups, :inverse_of=>:permission_group, :dependent=>:destroy
  has_many :lime_surveys, :through=>:permission_ls_groups
  has_many :role_aggregates, :through=>:lime_surveys
  has_many :assignment_group_templates, ->{ active },
    class_name: 'Assignment::AssignmentGroupTemplate'


  accepts_nested_attributes_for :permission_ls_groups, :allow_destroy=>true,
    :reject_if=>:all_blank
  validates_associated :permission_ls_groups
  attr_accessible :permission_ls_groups_attributes, :allow_destroy=>true
  attr_accessible :title, :user_ids, :pinned_survey_group_titles
  validates :title, presence: true, uniqueness: true

  serialize :pinned_survey_group_titles, Array

  rails_admin do
    navigation_label 'Permissions'
    list do
      field :id
      field :title
      field :users
    end
    edit do
      field :title, :string
      field :users
      field :permission_ls_groups do
        label 'Surveys'
      end
      field :pinned_survey_group_titles do
        label "Pinned Survey Groups"
        help "Survey groups that are pinned to the users nav bar"
      end
    end
  end

  ##
  # Names of every survey group available
  def survey_group_titles
    @survey_group_titles ||= survey_groups.titles
  end

  ##
  # Enum for pinning survey groups
  def pinned_survey_group_titles_enum
    survey_group_titles
  end

  ##
  # Group surveys by title
  def survey_groups
    @survey_groups ||= LimeExt::LimeSurveyGroup.classify(lime_surveys)
  end

  ##
  # Only pinned surveys, grouped by title
  def pinned_survey_groups
    @pinned_survey_groups ||= survey_groups.filter(pinned_survey_group_titles)
  end

  ##
  # Calculate the role_aggregate that this user can see
  def role_aggregates_for user
    details, result = explain_role_aggregates_for user
    return result
  end

  ##
  # TODO: Move to helper
  def explain_role_aggregates_for user
    details = []
    result = role_aggregates.select{|ra|
      ready = ra.ready_for_use?
      details.push([ra, 'RA not ready for use']) unless ready
      ready
    }

    # remove RA where user doesn't have permission (missing user externals)
    uex = user.user_externals
    permission_ls_groups.each do |plg|
      ra = plg.lime_survey.role_aggregate
      unless plg.ready_for_use?
        unless ra.nil?
          details.push([ra.lime_survey_title, 'Permission ls group not ready for use'])
        end
        result.delete ra
        next
      end

      plg.permission_ls_group_filters.each do |plgk|
        next unless plgk.ident_type.present?
        match = uex.where(:ident_type=>plgk.ident_type).first
        if match.nil?
          result.delete ra
          details.push [ra,  "No User External matching: #{plgk.ident_type}"]
          break
        end
      end
    end

    # Remove RA where user has nothing to see in the dataset ie does not have records in the dataset
    result = result.select  do |ra|
      begin
        fm = LsReportsHelper::FilterManager.new user, ra.lime_survey_sid
        lime_data = fm.lime_survey.lime_data
        if lime_data.empty?
          details.push [ra, 'Empty dataset after filters']
        else
          details.push [ra, 'Ready']
        end
        !lime_data.empty?
      rescue LsReportsHelper::AccessDenied=>e
        details.push [ra, 'Access Denied Error']
        false
      end
    end

    return details, result
  end

end
