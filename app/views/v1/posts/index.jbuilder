json.page @page
json.posts do
  json.array! @posts do |post|
    json.call(post, :title, :body, :range, :min_rent, :max_rent, :rent, :livings, :rooms, :toilets)
    # json.post_type
    json.location do
      json.call(post.location, :name, :address)
    end
    json.timestamp post.trace_on_create
    unless post.is_a?(Post::Housemate)
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
