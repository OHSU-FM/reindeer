class Artifact < ApplicationRecord
  belongs_to :user
  has_many_attached :documents
  # Note that implicit association has a plural form in this case
  scope :with_eager_loaded_images, -> { eager_load(images_attachments: :blob) }

  validates :documents, presence: true, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'application/pdf'], size_range: 1..10.megabytes }

end
