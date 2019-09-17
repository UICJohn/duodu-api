json.posts do
  json.array! @posts do |post|
    json.(post, :city, :post_type, :province, :title, :body, :country, :address, :suburb, :lon, :lat, :range, :min_rent, :max_rent, :rent, :rent_type, :available_from, :livings, :rooms, :toilets)
    json.timestamp post.trace_on_create
    json.attachments do
      json.array! post.attachments.limit(4) do |attachment|
        # json.(attachment, :id, :service_url)
          json.id attachment.id
          json.url rails_blob_url(attachment)

      end
    end
    json.user do
      json.username post.user.username
      json.avatar rails_blob_url(post.user.avatar)
      json.gender post.user.gender
    end
  end
end