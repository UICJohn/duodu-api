module PostImageable
  extend ActiveSupport::Concern
  included do
    validate  :can_active?

    def cover_image
      cover_image_id.blank? ? images.attachments.first : images.attachments.find_by(id: cover_image_id)
    end

    private

    def can_active?
      if active? && images.blank?
        errors.add(:images, 'you need to upload images')
      end
    end
  end
end
