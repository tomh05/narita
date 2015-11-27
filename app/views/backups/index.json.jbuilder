json.array!(@backups) do |backup|
  json.extract! backup, :id, :started, :ended, :username, :ref
  json.url backup_url(backup, format: :json)
end
