json.page @page
json.posts do  
  json.array! @posts do |post|
    json.(post, :title, :body, :range, :min_rent, :max_rent, :rent, :livings, :rooms, :toilets)
    # json.post_type
    json.location do
      json.(post.location, :name, :address)
    end
    json.timestamp post.trace_on_create
    json.attachments do
      json.array! post.attachments.limit(4) do |attachment|
        json.id attachment.id
        json.url rails_blob_url(attachment)
      end
    end unless post.is_a?(Post::Housemate)
    json.user do
      json.username post.user.username
      json.avatar rails_blob_url(post.user.avatar) if post.user.avatar.attached?
      json.gender post.user.gender
    end
  end
end