class UmeBls < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  self.table_name = "ume_blses"
end
