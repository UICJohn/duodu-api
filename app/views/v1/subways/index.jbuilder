json.subways @subways do |subway|
  json.cache! ['v1', subway] do
    json.call(subway, :id, :name)
    json.stations do
      json.array! subway.stations.active do |station|
        json.call(station, :id, :name)
      end
    end
  end
end
