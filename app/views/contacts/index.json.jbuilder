json.array!(@contacts) do |contact|
  json.extract! contact, :id, :event_time, :contact_name, :contact_number
  json.url contact_url(contact, format: :json)
end
