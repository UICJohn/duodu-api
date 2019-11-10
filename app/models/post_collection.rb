class PostCollection < ApplicationRecord
  belongs_to :user
  belongs_to :post, class_name: 'Post::Base'
end