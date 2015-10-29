json.array!(@apps) do |app|
  json.extract! app, :id, :event_time, :app_name
  json.url app_url(app, format: :json)
end
