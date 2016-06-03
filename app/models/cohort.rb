class Cohort < ActiveRecord::Base

  belongs_to :owner, class_name: "User", foreign_key: :user_id
  belongs_to :permission_group

  has_many :users
  has_many :assignment_groups

  validates :permission_group, presence: true
  validates :owner, presence: true
  validates :title, presence: true

  before_validation :set_defaults, on: :create

  rails_admin do
    navigation_label 'Permissions'
    weight -5

    list do
      field :id do
        read_only true
      end
      include_all_fields
    end
    field :owner
    field :users
    field :title
    field :title
    field :permission_group
    field :assignment_groups
  end

  def users
    User.where(cohort: self)
  end

  def assignment_groups
    Assignment::AssignmentGroup.where(cohort: self)
  end

  def possible_users
    @possible_users ||= permission_group.present? ? permission_group.users : []
  end

  def user_ids_enum
    @user_ids_enum ||= possible_users.map{|u| [u.title, u.id] }
  end

  protected

  def set_defaults
    self.title = owner.email unless self.title
    self.user_ids = possible_users.map {|u| u.id } unless user_ids.present?
  end
end
