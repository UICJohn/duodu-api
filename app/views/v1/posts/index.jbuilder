json.page @page
json.posts do
  json.array! @posts do |post|
    json.call(post, :id, :body, :title)
    json.type post.type.split('::').last.underscore
    json.view_count Warehouse::PostFact.count_view_for(post)
    json.like current_user.like_post_ids.include?(post.id) if current_user.present?
    json.comments_count post.comments_count
    json.like_count post.post_collections.count('distinct user_id')
    json.available_from post.available_from.to_date

    json.location do
      json.call(post.location, :name, :address)
      json.suburb post.location.suburb.try(:name)
      json.city post.location.city.try(:name)
    end

    if post.type == 'Post::HouseMate'
      json.call(post, :min_rent, :max_rent)
    else
      json.call(post, :rent, :livings, :rooms, :toilets)
      json.tenants post.tenants if post.type == 'Post::ShareHouse'
    end

    json.cover_image post.cover_image_url

    json.user do
      json.username post.user.username
      json.avatar post.user.avatar.url if post.user.avatar.attached?
      json.gender post.user_gender
    end
    json.timestamp post.tracer
  end
end
