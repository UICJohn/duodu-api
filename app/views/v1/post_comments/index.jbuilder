json.comments @comments do |comment|
  json.partial! 'comment', comment: comment
  json.sub_comments sub_comments do
    comment.sub_comments.each do |sub_comment|
      json.partial! 'comment', comment: sub_comment
    end
  end
end