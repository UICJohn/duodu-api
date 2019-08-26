json.schools @schools do |school|
  json.cache! ["v1", school] do
    json.(school, :id, :name)
  end
end
