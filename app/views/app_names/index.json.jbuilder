json.array!(@app_names) do |app_name|
  json.extract! app_name, :id, :longname, :shortname, :color, :priority
  json.url app_name_url(app_name, format: :json)
end
