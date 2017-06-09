class Review < ActiveRecord::Base
  belongs_to :user

  has_many :sources
  has_many :role_aggregates, through: :sources

  enum user_type: [:md, :icuapp, :crna]

  validates :user, :user_type, presence: true

  SOURCE_TYPES = [:role_aggregates, :on_time_starts]

  def method_missing name, *args, &block
    if SOURCE_TYPES.include? name
      sources.map {|s|
        s.sourceable if s.sourceable_type == name.to_s.classify
      }
    else
      super
    end
  end

  # a list of hashes
  def on_time_starts_by_site
    on_time_starts
  end
end
