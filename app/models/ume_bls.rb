class UmeBls < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  self.table_name = "ume_blses"

  rails_admin do
    list do
      exclude_fields :created_at
      field :user do
        visible visible
        queryable true
        searchable [{User => :full_name}]
      end
    end
  end
end
