json.post do
  json.id @post.id
  json.call(@post, :title, :body, :type, :available_from, :tenants)

  json.view_count Warehouse::PostFact.count_view_for(@post)
  json.comments_count @post.comments_count
  json.like_count @post.post_collections.count('distinct user_id')

  json.like current_user.like_post_ids.include?(@post.id) if current_user.present?
  json.timestamp @post.tracer

  json.comments @post.comments do |comment|
    json.partial! '/v1/post_comments/comment', comment: comment
    json.sub_comments comment.sub_comments do |sub_comment|
      json.partial! '/v1/post_comments/comment', comment: sub_comment
    end
  end

  json.user do
    json.username @post.user.username
    json.avatar @post.user.avatar.url if @post.user.avatar.attached?
    json.gender @post.user_gender
    json.age    @post.user.age
  end

  if @post.is_a?(Post::HouseMate)
    json.call(
      @post,
      :min_rent,
      :max_rent,
      :has_pets,
      :pets_allow,
      :smoke_allow,
      :tenants_gender
    )
  else
    json.call(
      @post,
      :payment_type,
      :rent,
      :livings,
      :rooms,
      :toilets,
      :property_type,
      :has_furniture,
      :has_appliance,
      :has_network,
      :has_air_conditioner,
      :has_elevator,
      :has_cook_top,
      :has_pets,
      :pets_allow,
      :smoke_allow,
      :tenants_gender
    )
    json.images do
      json.array! @post.images.map(&:url)
    end

    json.cover_image @post.cover_image_url    

    json.location do
      json.call(@post.location, :country, :name, :address, :city, :longitude, :latitude, :suburb)
    end
  end
end
