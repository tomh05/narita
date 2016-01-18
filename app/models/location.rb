require 'csv'
class Location < ActiveRecord::Base
  def self.import(csv_text)
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      parsed_event_time = DateTime.parse(row[4].to_s)
      location = Location.find_or_initialize_by(event_time: parsed_event_time, lat: row[2].to_s, long: row[3].to_s, username: row[5].to_s)
      location.save
    end
  end
end
