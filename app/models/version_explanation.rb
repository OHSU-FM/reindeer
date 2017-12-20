class VersionExplanation < ActiveRecord::Base
  belongs_to :version_note
  belongs_to :version

  rails_admin do
    navigation_label 'Dataset Changes'
  end
end
