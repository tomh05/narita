json.array!(@facebook_messages) do |facebook_message|
  json.extract! facebook_message, :id, :fb_date, :fb_content, :fb_from, :username
  json.url facebook_message_url(facebook_message, format: :json)
end
