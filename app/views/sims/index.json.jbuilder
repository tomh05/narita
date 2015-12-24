json.array!(@sims) do |sim|
  json.extract! sim, :id, :event_time, :event_type, :username
  json.url sim_url(sim, format: :json)
end
