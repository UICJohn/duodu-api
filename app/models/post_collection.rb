class PostCollection < ApplicationRecord
  belongs_to :user
  belongs_to :post, class_name: 'Post::Base'

  after_create :push_creation_log
  after_destroy :push_destroy_log

  private

  def push_creation_log
    Etl::LikePost.process(user_id: user.id, post_id: post.id)
  end

  def push_destroy_log
    Etl::DislikePost.process(user_id: user.id, post_id: self.post_id)
  end
end