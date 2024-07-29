class FomLabel < ApplicationRecord
    belongs_to :fom_exam, optional: true
end

RailsAdmin.config do |config|
  config.model 'FomLabel' do
    list do
      field :id
      sort_by 'permission_group_id desc, fom_labels.course_code'
      field :permission_group_id
      field :course_code
      field :labels
      field :block_enabled
    end
  end
end
