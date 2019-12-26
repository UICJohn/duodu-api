class Warehouse::PostFact < ApplicationRecord
  belongs_to :user
  belongs_to :post, class_name: 'Post::Base'
  belongs_to :warehouse_date_dimension, foreign_key: 'date_id', class_name: 'Warehouse::DateDimension'

  enum action: { view: 0, like: 2, dislike: 3 }

  class << self
    Warehouse::PostFact.actions.each do |action, idx|
      define_method "count_#{action}_for" do |post|
        where(
          post_id: post.id,
          action: idx
        ).count(:id)  
      end
    end
  end
end