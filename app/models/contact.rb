class Contact < ActiveRecord::Base
  def self.import(csv_text)
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      parsed_event_time = DateTime.parse(row[0].to_s+'_'+row[1].to_s)
      contact = Contact.find_or_initialize_by(contact_name: row[2].to_s, contact_number: row[3].to_s, username: row[4].to_s)
      contact.event_time = parsed_event_time
      contact.save
    end
  end
end
