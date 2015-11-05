module Assignment
  class AssignmentGroup < ActiveRecord::Base
    serialize :user_ids, Array

    belongs_to :owner, class_name: 'User', foreign_key: :user_id
    belongs_to :assignment_group_template
    has_one :permission_group, through: :assignment_group_template
    has_many :survey_assignments
    has_many :comments, class_name: 'Assignment::AssignmentComment', 
      inverse_of: :assignment_group   
    delegate :lime_surveys, to: :assignment_group_template
    validates :owner, presence: true
    validates :assignment_group_template, presence: true
    STATES = {
      1 => :active,
      2 => :inactive,
      3 => :complete
    }
    
    attr_accessible :user_id, :title, :desc_md, :user_ids

    rails_admin do
      field :id do
        read_only true
      end
      field :owner, :belongs_to_association
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

    def users_enum
      @users_enum ||= assignment_group_template.possible_users.map{|u|
        [u.title, u.id]
      }
    end
    
    def _user_ids
      @user_ids_int ||= user_ids.select{ |v| v.present? }
    end

    def users
      User.where(["id in (?)", _user_ids])
    end

    def user_ids_enum
      @user_ids_enum ||= users_enum.map{|u|[u.title, u.id]}
    end

  end
end
