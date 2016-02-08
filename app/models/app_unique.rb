require 'csv'
class AppUnique < ActiveRecord::Base
    def self.username(name)
        where(username: name)
    end
    def self.daterange(from,to)
        where(event_time: from..to)
    end
  def self.import(csv_text)
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      #parsed_event_time = DateTime.parse(row[0].to_s+'_'+row[1].to_s)
      parsed_event_time = DateTime.parse(row[3].to_s)
      #app = AppUnique.find_or_initialize_by(event_time: parsed_event_time, app_name: row[2].to_s, username: row[3].to_s)
      app = AppUnique.find_or_initialize_by(event_time: parsed_event_time, app_name: row[2].to_s, username: row[4].to_s)
      app.save
    end
  end
  def self.username(name)
    where(username: name)
  end
  def self.daterange(from,to)
    where(event_time: from..to)
  end

  def self.as_csv
    CSV.generate do |csv|
      #csv << column_names
      csv << ["Participant","Type","Timestamp","Detail"]
      #TODO encrypt participant
      all.each do |item|
        #csv << item.attributes.values_at(*column_names)
        ident = Person.username(item.username).select("identifier").first.identifier
        if !ident.present?
          ident = "ERR"
        end
        csv << [ident,"App Launch",item.event_time,item.app_name]
      end
    end
  end


end
