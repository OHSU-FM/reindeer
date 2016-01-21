class VersionExplanation < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :version_note
  belongs_to :version

    rails_admin do
        navigation_label 'Dataset Changes'
    end
end
