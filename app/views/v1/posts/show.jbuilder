json.post do
  json.id @post.id
  json.(@post, :title, :body, :post_type, :range, :min_rent, :max_rent, :payment_type, :lease_type, :available_from, :has_sofa, :has_bed, :has_air_conditioner, :has_elevator, :has_washing_machine, :has_cook_top, :has_refregitor)
  json.location do
    json.(@post.location, :country, :name, :address, :city, :longitude, :latitude, :suburb)
  end
end