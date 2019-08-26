json.occupations @occupations do |occupation|
  json.cache! ['v1', occupation] do
    json.(occupation, :id, :name)
  end
end