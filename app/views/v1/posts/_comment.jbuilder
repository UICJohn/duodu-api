json.call(comment, :id, :body, :tracer)
json.user do
  json.avatar comment.user.avatar.service_url if comment.user.avatar.attached?
  json.username comment.user.username
  json.gender comment.user.gender
end