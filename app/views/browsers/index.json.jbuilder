json.array!(@browsers) do |browser|
  json.extract! browser, :id, :username, :title, :url
  json.url browser_url(browser, format: :json)
end
