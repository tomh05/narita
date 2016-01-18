require 'csv'
class FacebookMessage < ActiveRecord::Base
  def self.import(csv_text)
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      parsed_message_date = DateTime.parse(row[4].to_s)
      fb = FacebookMessage.find_or_initialize_by(fb_from: row[2].to_s, fb_content: URI.unescape(row[3].to_s), username: row[7].to_s)
      fb.fb_date = parsed_message_date
      fb.message_type = row[5].to_s
      fb.stack_level = row[6].to_int
      fb.save
    end
  end
end
