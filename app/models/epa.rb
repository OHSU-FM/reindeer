class Epa < ApplicationRecord
  belongs_to :user

  rails_admin do
    list do

      exclude_fields :updated_at
      field :response_id do
        visible visible
        queryable true
        searchable [{Epa => :response_id}]
      end
    end
  end

end
