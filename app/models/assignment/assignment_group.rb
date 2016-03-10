module Assignment
  class AssignmentGroup < ActiveRecord::Base
    include Assignment::MarkdownFilter
    markdown_columns :desc_md

    serialize :user_ids, Array

    belongs_to :owner, class_name: 'User', foreign_key: :user_id
    belongs_to :assignment_group_template
    has_one :permission_group, through: :assignment_group_template
    has_many :survey_assignments
    has_many :comments, class_name: 'Assignment::AssignmentComment',
      inverse_of: :assignment_group, dependent: :destroy
    delegate :lime_surveys, to: :assignment_group_template
    validates :owner, presence: true
    validates :assignment_group_template, presence: true

    before_validation :set_defaults, on: :create

    STATES = {
      1 => :active,
      2 => :inactive,
      3 => :complete
    }

    rails_admin do
      list do
        field :id do
          read_only true
        end
        include_all_fields
      end
      field :owner, :belongs_to_association do
        default_value do
          bindings[:view]._current_user
        end
      end
      field :assignment_group_template
      field :status
      field :title
      field :desc_md
      field :user_ids
      field :survey_assignments
    end

    def status_enum
      STATES.invert
    end

    def assignment_group_template_enum
      AssignmentGroupTemplate.active
    end

    def possible_users
      assignment_group_template ? assignment_group_template.possible_users : []
    end

    def user_ids_enum
      @user_ids_enum ||= possible_users.map{|u|[u.title, u.id]}
    end

    # array of user_assignments in this assignment_group belonging to user
    def user_assignments_for user_id
      user_assignments = []
      self.survey_assignments.each do |sa|
        user_assignments << sa.user_assignments.where(user_id: user_id)
      end
      return user_assignments.flatten()
    end

    protected

    def set_defaults
      agt = assignment_group_template
      return unless agt.present?
      self.title = agt.title unless title.present?
      self.desc_md = agt.desc_md unless desc_md.present?
      self.user_ids = agt.possible_users.map{|u|u.id} unless user_ids.present?
      self.status = STATES.invert[:active] unless status.present?
    end

  end
end
