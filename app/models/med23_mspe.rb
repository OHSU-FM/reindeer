class Med23Mspe < ApplicationRecord
  belongs_to :user
  has_many :competencies, through: :user
end
