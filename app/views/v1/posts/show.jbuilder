json.post do
  json.id @post.id
  json.(@post, :title, :body, :post_type, :address, :range, :min_rent, :max_rent, :payment_type, :rent_type, :available_from, :has_sofa, :has_bed, :has_air_conditioner, :has_elevator, :has_washing_machine, :has_cook_top, :has_refregitor)
end