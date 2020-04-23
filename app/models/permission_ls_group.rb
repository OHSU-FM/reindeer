class PermissionLsGroup < ActiveRecord::Base
  belongs_to :lime_survey, primary_key: :sid, foreign_key: :lime_survey_sid,
   inverse_of: :permission_ls_groups
  belongs_to :permission_group, inverse_of: :permission_ls_groups

  has_one :role_aggregate, through: :lime_survey
  has_many :permission_ls_group_filters, dependent: :destroy,
   inverse_of: :permission_ls_group

  validates_presence_of :lime_survey, :permission_group
  validates_presence_of :role_aggregate
  validates_uniqueness_of :lime_survey_sid, scope: :permission_group_id
  validate :validate_enabled_allowed

  accepts_nested_attributes_for :permission_ls_group_filters, allow_destroy: true

  def validate_enabled_allowed
    if enabled && !enabled_allowed?
      if !role_aggregate.present?
        # Must explicitly allow view_all, or have filters
        errors.add(:enabled, 'No role_aggregate defined')
      elsif !role_aggregate.ready_for_use?
        errors.add(:enabled, 'Role aggregate configuration is not complete')
      else
        # Must explicitly allow view_all, or have filters
        errors.add(:enabled, 'requires "view all" or enabled filters')
      end
    end
  end

  def enabled_allowed?
    return role_aggregate.present? && role_aggregate.ready_for_use? && (
      view_all == true || permission_ls_group_filters.select{|plgf| plgf.enabled? }.count > 0
    )
  end

  def ready_for_use?
    enabled && enabled_allowed?
  end

  rails_admin do
    visible false

    edit do
      field :ready_for_use?, :boolean do
       read_only true
      end

      field :permission_group do
        inline_add false
        inline_edit false
      end

      field :lime_survey do
        LimeSurvey.with_data_table.map{|ls| ls.title }.sort_by{|e| e[0] }
      end

      field :enabled
      field :view_raw
      field :view_all
      field :permission_ls_group_filters do
        label 'Survey permissions'
      end
    end
  end

  def name
    _name = lime_survey.nil? ? 'Untitled' : lime_survey.title
    "#{_name}#{' (disabled)' if disabled?}"
  end

  def disabled?
    !ready_for_use?
  end
end
