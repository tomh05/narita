json.array!(@sms_messages) do |sms_message|
  json.extract! sms_message, :id, :event_time, :sms_content, :sms_sender
  json.url sms_message_url(sms_message, format: :json)
end
