require 'csv'
class Screen < ActiveRecord::Base
  def self.import(csv_text)
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      if (row.size > 4)
        #parsed_event_time = DateTime.parse(row[0].to_s+'_'+row[1].to_s)
        parsed_event_time = DateTime.parse(row[3].to_s)
        #app = Screen.find_or_initialize_by(event_time: parsed_event_time, event_type: row[2].to_s, username: row[3].to_s)
        app = Screen.find_or_initialize_by(event_time: parsed_event_time, event_type: row[2].to_s, username: row[4].to_s)
        app.save
      end
    end
  end
end
