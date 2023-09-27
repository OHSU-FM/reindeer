class Med24Mspe < ApplicationRecord
  belongs_to :user
  has_many :competencies, through: :user
end
