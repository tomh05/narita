require 'csv'
class Backup < ActiveRecord::Base
  def self.import(csv_text)
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      parsed_event_time = DateTime.parse(row[2].to_s)
      backup = Backup.find_or_initialize_by(started: parsed_event_time, username: row[3].to_s, ref: row[4].to_s)
      backup.save
    end
  end
end
