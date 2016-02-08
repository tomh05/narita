require 'csv'
class SmsMessage < ActiveRecord::Base
  def self.import(csv_text)
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      parsed_sms_date = DateTime.parse(row[6].to_s)
      @sms = SmsMessage.find_or_initialize_by(sms_sender: row[2].to_s, sms_content: URI.unescape(row[7].to_s), username: row[4].to_s)
      @sms.sms_date = parsed_sms_date
      @sms.white_list = row[5].to_s
      @sms.sms_folder = row[3].to_s
      @sms.save
    end
  end
  def self.username(name)
    where(username: name)
  end
  def self.number(num)
    where(sms_sender: num)
  end
  def self.daterange(from,to)
    where(sms_date: from..to)
  end

  def self.as_csv
    CSV.generate do |csv|
      #csv << column_names
      csv << ["Participant","Type","Timestamp","Direction","To or From (hashed)","Character Count"]
      #TODO encrypt participant
      all.each do |item|
        #csv << item.attributes.values_at(*column_names)
        senderHash = Digest::SHA2.new(512).hexdigest(item.sms_sender)
        if item.sms_folder == "sent"
          direction = "outgoing"
        elsif item.sms_folder == "inbox"
          direction = "incoming"
        else
          direction = "ERR"
        end
        ident = Person.username(item.username).select("identifier").first.identifier
        if !ident.present?
          ident = "ERR"
        end
        csv << [ident,"SMS",item.sms_date,direction,senderHash,item.sms_content.length]
      end
    end
  end
end
