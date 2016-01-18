class Browser < ActiveRecord::Base
  def self.import(csv_text)
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      parsed_visit_date = DateTime.parse(row[4].to_s)
      browser = Browser.find_or_initialize_by(title: row[2].to_s, url: row[3].to_s, visit_total: row[5].to_i, username: row[6].to_s)
      browser.visit_date = parsed_visit_date
      browser.save
    end
  end
end
