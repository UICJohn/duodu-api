json.page @page
json.posts do
  json.array! @posts do |post|
    json.call(post, :body, :title, :user_id, :type)
    if post.type == 'Post::TakeHouse'
      json.call(
        post,
        :payment_type,
        :rent,
        :livings,
        :rooms,
        :toilets,
        :property_type,      
      )
      json.location do
        json.call(post.location, :name, :address)
        json.city post.location.try(:city).try(:name)
        json.suburb post.location.try(:suburb).try(:name)
      end
    elsif post.type == "Post::HouseMate"
      json.call(
        post,
        :min_rent,
        :max_rent
      )
      json.locations do 
        json.array! post.locations do |location|
          json.call(location, :name, :address)
          json.city location.try(:city).try(:name)
          json.suburb location.try(:suburb).try(:name)
        end
      end
    else
      json.call(
        post,
        :payment_type,
        :rent,
        :livings,
        :rooms,
        :toilets,
        :property_type,      
      )
      json.location do
        json.call(post.location, :name, :address)
        json.city post.location.try(:city).try(:name)
        json.suburb post.location.try(:suburb).try(:name)
      end
    end

    json.timestamp post.trace_on_create
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
      json.gender post.user.gender
    end
  end
end
