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
    where(event_time: from..to)
  end
end
