json.comments @post.comments do |comment|
  json.partial! 'comment', comment: comment
  json.sub_comments comment.sub_comments do |sub_comment|
    json.partial! 'comment', comment: sub_comment
  end
end