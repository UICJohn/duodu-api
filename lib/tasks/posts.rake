require 'net/http'

namespace :posts do
  task activate: :environment do
    Post::Base.where(active: false).find_each do |post|
      post.update(active: true) if post.can_active?
    end
  end
end
