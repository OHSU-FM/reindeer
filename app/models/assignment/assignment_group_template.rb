class Assignment::AssignmentGroupTemplate < ActiveRecord::Base
  has_many :assignment_groups
  belongs_to :permission_group, inverse_of: :assignment_group_templates, class_name: 'PermissionGroup'
  validates :lime_surveys, presence: true
  validates :permission_group, presence: true
  validates :title, presence: true
  scope :active, -> { where(active: true) }

  serialize :sids, Array
  attr_accessible :permission_group_id, :title, :sids, :desc_md

  STATES = {
    inactive: 0,
    active: 1,
    stopped: 2
  }

  rails_admin do
    edit do
      field :permission_group, :belongs_to_association do
        inline_edit false
        inline_add false
      end
      field :title
      field :desc_md do
        label 'Description'
      end

      field :sids do
        label 'Lime Surveys'
      end
    end
  end

  ##
  # Select users that are available to add from permission_group
  def possible_users
    @possible_users ||= permission_group.present? ? permission_group.users : []
  end

  def lime_surveys_enum
    @lime_surveys_enum ||= LimeSurvey.active
  end

  def permission_group_enum
    @permission_group_enum ||= PermissionGroup.all
  end

  def lime_surveys
    @lime_surveys ||= LimeSurvey.where('sid in (?)', sids)
  end

  def sids
    self[:sids].map{|v| v.to_i unless v.empty?}.compact
  end

  def sids_enum
    LimeSurvey.active.map{|ls|[ls.title, ls.sid]}
  end

end
