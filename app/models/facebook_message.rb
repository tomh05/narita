require 'csv'
class FacebookMessage < ActiveRecord::Base
  def self.import(csv_text)
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      parsed_message_date = DateTime.parse(row[4].to_s)
      fb = FacebookMessage.find_or_initialize_by(fb_from: row[2].to_s, fb_content: URI.unescape(row[3].to_s), username: row[7].to_s)
      fb.fb_date = parsed_message_date
      fb.message_type = row[5].to_s
      fb.stack_level = row[6].to_i
      fb.save
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
      csv << ["Participant","Type","Timestamp","Direction","To or From (hashed)","Character Count"]
      #TODO encrypt participant
      all.each do |item|
        #csv << item.attributes.values_at(*column_names)
        senderHash = Digest::SHA2.new(512).hexdigest(item.fb_from)
        if item.message_type == "OUTGOING"
          direction = "outgoing"
        elsif item.message_type == "INCOMING"
          direction = "incoming"
        else
          direction = "ERR"
        end
        ident = Person.username(item.username).select("identifier").first.identifier
        if !ident.present?
          ident = "ERR"
        end
        csv << [ident,"Facebook Messenger",item.fb_date,direction,senderHash,item.fb_content.length]
      end
    end
  end



end
