json.suburbs @suburbs do |suburb|
  json.cache! ["v1", suburb] do
    json.(suburb, :id, :name)
  end
end
