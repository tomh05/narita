json.array!(@people) do |person|
  json.extract! person, :id, :first_name, :last_name, :phone, :alt_phone, :google, :facebook, :twitter, :identifier, :whitelist, :image, :gender, :notes
  json.url person_url(person, format: :json)
end
