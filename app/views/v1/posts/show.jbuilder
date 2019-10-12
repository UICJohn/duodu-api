json.post do
  json.id @post.id
  json.call(@post, :title, :body, :post_type, :available_from)
  if ["take_house", "share_house"].include?(@post.post_type)
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
      :tenants_gender,
    )
  elsif @post.post_type == "house_mate"
    json.call(
      @post, 
      :min_rent,
      :max_rent,
      :areas,
      :has_pets,
      :pets_allow,
      :smoke_allow,
      :tenants_gender,
    )
  end
  json.call(@post, )
  json.location do
    json.call(@post.location, :country, :name, :address, :city, :longitude, :latitude, :suburb)
  end
end
