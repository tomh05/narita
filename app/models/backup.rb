class Backup < ActiveRecord::Base
  def self.import(csv_text)
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      backup = Backup.find_or_initialize_by(username: row[3].to_s, ref: row[4].to_s)
      backup.save
    end
  end
end
