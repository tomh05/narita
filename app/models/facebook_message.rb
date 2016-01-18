class FacebookMessage < ActiveRecord::Base
  def self.import(csv_text)
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      parsed_message_date = DateTime.parse(row[6].to_s)
      fb = FacebookMessage.find_or_initialize_by(fb_from: row[2].to_s, fb_content: URI.unescape(row[7].to_s), username: row[4].to_s)
      fb.fb_date = parsed_message_date
      fb.white_list = row[5].to_s
      fb.sms_folder = row[3].to_s
      fb.save
    end
  end
end
