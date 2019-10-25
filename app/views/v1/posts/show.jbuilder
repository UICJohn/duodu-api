json.post do
  json.id @post.id
  json.call(@post, :title, :body, :type, :available_from)
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
      :user_id,
      :rent,
      :livings,
      :rooms,
      :toilets,
      :cover_image_id,
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
    json.location do
      json.call(@post.location, :country, :name, :address, :city, :longitude, :latitude, :suburb)
    end
  end
end
