class UsmleExam < ApplicationRecord
    belongs_to :user

    validates_presence_of :user_id,:message => "Missing User id!"
    validates_presence_of :exam_type,:message => "Please Provide Exam Type!"

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
