module PostImageable
  extend ActiveSupport::Concern
  included do
    def cover_image
      return nil unless images.attached?
      cover_image_id.blank? ? images.attachments.first : images.find_by(id: cover_image_id)
    end
  end
end
