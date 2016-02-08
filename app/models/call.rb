require 'csv'
class Call < ActiveRecord::Base
  def self.import(csv_text)
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      contact = Call.find_or_initialize_by(event_time: DateTime.parse(row[2].to_s), call_number: row[3], call_type: row[4], call_duration: row[5], username: row[6].to_s)
      contact.save
    end
  end
  def self.username(name)
    where(username: name)
  end
  def self.number(num)
    where(call_number: num)
  end
  def self.daterange(from,to)
    where(event_time: from..to)
  end

  def self.as_csv
    CSV.generate do |csv|
      #csv << column_names
      csv << ["Participant","Type","Timestamp","Direction","To or From (hashed)","Duration in Seconds"]
      #TODO encrypt participant
      all.each do |item|
        #csv << item.attributes.values_at(*column_names)
        senderHash = Digest::SHA2.new(512).hexdigest(item.call_number)
        if item.call_type == "OUTGOING"
          direction = "outgoing"
        elsif item.call_type == "INCOMING"
          direction = "incoming"
        else
          direction = "ERR"
        end
        ident = Person.username(item.username).select("identifier").first.identifier
        if !ident.present?
          ident = "ERR"
        end
        csv << [ident,"Phone Call",item.event_time,direction,senderHash,item.call_duration]
      end
    end
  end

end
