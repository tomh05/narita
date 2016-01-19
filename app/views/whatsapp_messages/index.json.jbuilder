json.array!(@whatsapp_messages) do |whatsapp_message|
  json.extract! whatsapp_message, :id, :wa_date, :wa_content, :wa_from, :username, :message_type, :stack_level
  json.url whatsapp_message_url(whatsapp_message, format: :json)
end
