json.array!(@locations) do |location|
  json.extract! location, :id, :event_time, :lat, :long
  json.url location_url(location, format: :json)
end
