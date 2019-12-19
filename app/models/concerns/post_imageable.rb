module PostImageable
  extend ActiveSupport::Concern

  included do
    def cover_image_url

      return nil if is_a?(Post::HouseMate) || !images.attached?

      cover_image_id.present? ? images.find_by(id: cover_image_id).url : images.first.url
    end
  end

end
