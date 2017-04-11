class Source < ActiveRecord::Base
  belongs_to :review
  belongs_to :sourceable, polymorphic: true

  validates :sourceable, presence: true
end
