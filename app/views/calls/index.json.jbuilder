json.array!(@calls) do |call|
  json.extract! call, :id, :event_time, :call_date, :call_number, :call_type, :call_duration
  json.url call_url(call, format: :json)
end
