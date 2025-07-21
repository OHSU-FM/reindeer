class Med26Mspe < ApplicationRecord
  belongs_to :user
  has_many :competencies, through: :user
end
