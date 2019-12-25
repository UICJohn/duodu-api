json.call(comment, :id, :body, :tracer)

if comment.target.is_a?(Comment)
  json.notifying_user comment.target.user.username
end

json.user do
  json.avatar comment.user.avatar.url if comment.user.avatar.attached?
  json.username comment.user.username
  json.gender comment.user.gender
end