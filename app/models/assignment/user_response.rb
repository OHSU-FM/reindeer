class Assignment::UserResponse < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_assignment
  has_many :comments, as: :commentable
  delegate :user, to: :user_assignment
  validates :user_assignment, presence: true
  validates :content, presence: true

  def self.dedupe
    grouped = all.group_by{|ur| [ur.title, ur.user.id, ur.category, ur.content]}
    grouped.values.each do |duplicates|
      first = duplicates.shift
      duplicates.each {|duplicate| duplicate.destroy }
    end
  end

  def populate_from_hash hash
    (attribute_names - ["id"]).each do |attr|
      if hash.has_key? attr
        self[attr.to_sym] = hash[attr]
      else
        self[attr.to_sym] = hash[hash.keys.select{|k| k.include? attr.camelize}.first]
      end
    end
    self
  end

  def assignment_group
    user_assignment.survey_assignment.assignment_group
  end

  def has_comments?
    !comments.empty?
  end

  # disregard sys comments
  def has_user_comments?
    !comments.collect{|c| c.flagged_as == "sys"}.all?
  end

  def ag_owner
    assignment_group.owner
  end
end
