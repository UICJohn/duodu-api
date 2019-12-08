json.post do
  json.id @post.id
  json.call(@post, :title, :body, :type, :available_from, :tenants)
  json.like_count @post.post_collections.count('distinct user_id')
  json.like current_user.like_post_ids.include?(@post.id) if current_user.present?
  json.timestamp @post.trace_on_create
  json.user do
    json.username @post.user.username
    json.avatar @post.user.avatar.service_url if @post.user.avatar.attached?
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
      json.array! @post.images do |image|
        json.url image.service_url if image.id != @post.cover_image_id
      end
    end

    json.cover_image @post.cover_image.url

    json.location do
      json.call(@post.location, :country, :name, :address, :city, :longitude, :latitude, :suburb)
    end
  end
end
