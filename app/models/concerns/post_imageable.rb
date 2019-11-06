module PostImageable
  extend ActiveSupport::Concern
  included do
    def cover_image
      cover_image_id.blank? ? images.attachments.first : images.attachments.find_by(id: cover_image_id)
    end
  end
end
