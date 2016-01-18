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
end
