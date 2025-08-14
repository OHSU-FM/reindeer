class Med26Mspe < ApplicationRecord
  belongs_to :user
  has_many :competencies, through: :user

  def before_import_save(record)
    if (email = record[:email]) && (user = User.find_by_email(email))
      self.user_id = user.id
    end
  end
end
