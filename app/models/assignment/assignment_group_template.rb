class Assignment::AssignmentGroupTemplate < ActiveRecord::Base

  has_many :assignment_groups
  belongs_to :permission_group
  serialize :sids, Array

  validates :lime_surveys, presence: true
  validates :title, presence: true

  STATES = {
    inactive: 0,
    active: 1,
    stopped: 2
  }
  
  def self.active
    where(active: true)
  end 

  def lime_surveys_enum
    @lime_surveys_enum ||= LimeSurvey.active
  end

  def permission_groups_enum
    @users_enum ||= PermissionGroup.all
  end

  def lime_surveys
    @lime_surveys ||= LimeSurvey.where('sid in (?)', sids)
  end

  def sids
    self[:sids].map{|v| v.to_i unless v.empty?}.compact
  end

end
