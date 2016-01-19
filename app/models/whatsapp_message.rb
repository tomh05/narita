require 'csv'
class WhatsappMessage < ActiveRecord::Base
  def self.import(csv_text)
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      parsed_message_date = DateTime.parse(row[4].to_s)
      wa = WhatsappMessage.find_or_initialize_by(wa_from: row[2].to_s, wa_content: URI.unescape(row[3].to_s), username: row[7].to_s)
      wa.wa_date = parsed_message_date
      wa.message_type = row[5].to_s
      wa.stack_level = row[6].to_i
      wa.save
    end
  end
end
