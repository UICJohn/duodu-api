json.comments @comments do |comment|
  json.call(comment, :id, :body, :tracer)
  json.user do
    json.username comment.user.username
    json.avatar comment.user.avatar.url if comment.user.avatar.attached?    
  end

  if (target = comment.target) && target.is_a?(Comment)
    json.reply do
      json.body target.body
      json.username target.user.username
    end
  end

  json.post do
    json.id comment.root.id
    json.username comment.root.user.username
    json.post_type comment.root.type.split('::').last.underscore
    json.body comment.root.body
    json.cover_image comment.root.cover_image_url
  end
end