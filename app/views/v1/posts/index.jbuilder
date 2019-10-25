json.page @page
json.posts do
  json.array! @posts do |post|
    json.call(post, :id, :body, :title)
    json.type post.type.split('::').last.underscore
    if post.type == 'Post::TakeHouse'
      json.call(
        post,
        :payment_type,
        :rent,
        :livings,
        :rooms,
        :toilets,
        :property_type
      )
      json.location do
        json.call(post.location, :name, :address, :city_name, :suburb_name)
      end
    elsif post.type == 'Post::HouseMate'
      json.call(
        post,
        :min_rent,
        :max_rent
      )
      json.locations do
        json.array! post.locations do |location|
          json.call(location, :name, :address, :city_name, :suburb_name)
        end
      end
    else
      json.call(
        post,
        :payment_type,
        :rent,
        :livings,
        :rooms,
        :tenants,
        :toilets,
        :property_type
      )
      json.location do
        json.call(post.location, :name, :address, :city_name, :suburb_name)
      end
    end

    unless post.is_a?(Post::HouseMate)
      json.images do
        json.array! post.images.limit(4) do |image|
          json.id image.id
          json.url rails_blob_url(image)
        end
      end
    end

    json.user do
      json.username post.user.username
      json.avatar rails_blob_url(post.user.avatar) if post.user.avatar.attached?
      json.gender post.user_gender
    end
    json.timestamp post.trace_on_create
  end
end
