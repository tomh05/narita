require 'csv'
class App < ActiveRecord::Base
  def self.import(csv_text)
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      app = App.find_or_initialize_by(app_name: row[2].to_s, event_type: row[5].to_s, username: row[6].to_s)
      app.total_use = row[3].to_s
      app.last_used = DateTime.parse(row[4].to_s)
      app.save
    end
  end
  def self.username(name)
    where(username: name)
  end
end
