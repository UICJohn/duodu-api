json.occupations @occupations do |occupation|
  json.cache! ['v1', occupation] do
    json.call(occupation, :id, :name)
  end
end
