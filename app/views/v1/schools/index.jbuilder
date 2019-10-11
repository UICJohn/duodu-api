json.schools @schools do |school|
  json.cache! ['v1', school] do
    json.call(school, :id, :name)
  end
end
