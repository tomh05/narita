json.array!(@screens) do |screen|
  json.extract! screen, :id, :event_time, :event_type, :username
  json.url screen_url(screen, format: :json)
end
