json.array!(@app_uniques) do |app_unique|
  json.extract! app_unique, :id, :event_time, :app_name, :username, :event_type
  json.url app_unique_url(app_unique, format: :json)
end
