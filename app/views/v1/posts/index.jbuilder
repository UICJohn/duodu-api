json.page @page
json.posts do
  json.array! @posts do |post|
    json.call(post, :body, :title, :user_id, :post_type)
    if ["take_house", "share_house"].include?(post.post_type)
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
      end
    elsif post.post_type == "house_mate"
      json.call(
        post,
        :min_rent,
        :max_rent,
        :areas,        
      )
    end

    json.timestamp post.trace_on_create
    unless post.is_a?(Post::HouseMate)
      json.attachments do
        json.array! post.attachments.limit(4) do |attachment|
          json.id attachment.id
          json.url rails_blob_url(attachment)
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
