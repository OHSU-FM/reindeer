class Assignment::AssignmentGroupTemplate < ActiveRecord::Base
  has_many :assignment_groups
  validates :lime_surveys, presence: true
  validates :title, presence: true
  scope :active, -> { where(active: true) }

  serialize :sids, Array
  attr_accessible :title, :sids, :desc_md,
    :lime_surveys

  STATES = {
    inactive: 0,
    active: 1,
    stopped: 2
  }

  rails_admin do
    edit do
      field :title
      field :desc_md do
        label 'Description'
      end

      field :sids do
        sortable "datecreated"
        label 'Lime Surveys'
      end
    end
  end

  def lime_surveys_enum
    @lime_surveys_enum ||= LimeSurvey.active
  end

  def lime_surveys=(vals)
    self.sids = vals.map{|v| v.sid.to_s }
    @lime_surveys = vals
  end

  def lime_surveys
    @lime_surveys ||= LimeSurvey.where("sid in (?)", sids)
  end

  def sids
    self[:sids].map{|v| v.to_i unless v.empty?}.compact
  end

  def sids_enum
    LimeSurvey.active.map{|ls|[ls.title, ls.sid]}
  end

end
