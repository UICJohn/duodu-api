json.posts do
  json.array! @posts do |post|
    json.(post, :city, :province, :title, :body, :country, :address, :suburb, :lon, :lat, :range, :min_rent, :max_rent, :rent, :rent_type, :available_from, :livings, :rooms, :toilets)
    json.timestamp post.trace_on_create
    json.attachments do
      json.array! post.attachments do |attachment|
        json.(attachment, :id, :service_url)
      end
    end
    json.user do
      json.username post.user.username
      json.avatar post.user.avatar.try(:service_url)
      json.gender post.user.gender
    end
  end
end