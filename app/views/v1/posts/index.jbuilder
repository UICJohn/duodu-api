json.page @page
json.posts do
  json.array! @posts do |post|

    json.call(post, :id, :body, :title)
    json.type post.type.split('::').last.underscore

    if post.type == 'Post::HouseMate'
      json.call(post, :min_rent, :max_rent)
      json.locations do
        json.array! post.locations do |location|
          json.call(location, :name, :address, :city_name, :suburb_name)
        end
      end
    else
      json.call(post, :rent, :livings, :rooms, :toilets)
      json.location do
        json.call(post.location, :name, :address, :city_name, :suburb_name)
      end  
      json.tenants post.tenants if post.type == 'Post::ShareHouse'
    end

    if !post.is_a?(Post::HouseMate) && (image = post.cover_image).present?
      json.image rails_blob_url(image)
    end

    json.user do
      json.username post.user.username
      json.avatar rails_blob_url(post.user.avatar) if post.user.avatar.attached?
      json.gender post.user_gender
    end
    json.timestamp post.trace_on_create
  end
end
