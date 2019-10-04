json.subways @subways do |subway|
  json.cache! ["v1", subway] do
    json.(subway, :id, :name)
    json.stations do
      json.array! subway.stations do |station|
        json.(station, :id, :name)
      end
    end
  end
end
