class Review < ActiveRecord::Base
  belongs_to :user

  has_many :sources
  has_many :role_aggregates, through: :sources

  validates :user, presence: true

  def role_aggregates
    sources.map{|s|
      s.sourceable if s.sourceable_type == "RoleAggregate"
    }
  end
end
