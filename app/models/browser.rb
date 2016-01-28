require 'csv'
class Browser < ActiveRecord::Base
  def self.import(csv_text)
    #csv_text.gsub(/([^,])"([^,])/,'\1\"\2') # Hacky fix to remove quotes inside web titles
    #csv = CSV.parse(csv_text, :headers => false)
    #csv.each do |row|
    csv_text.each_line do |line|
      pattern = /([0-9]{1,2}-[0-9]{1,2}-[0-9]{1,4}),([0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}),"(.*)","([^"]*)",([^"]*),"([0-9]+)","(.*)"/
      matches = pattern.match(line)
      if matches
        row = matches
        parsed_visit_date = DateTime.parse(row[5].to_s)
        browser = Browser.find_or_initialize_by(title: row[3].to_s, url: row[4].to_s, visit_total: row[6].to_i, username: row[7].to_s)
        browser.visit_date = parsed_visit_date
        browser.save
      end
    end
  end
  def self.username(name)
    where(username: name)
  end
  def self.daterange(from,to)
    where(visit_date: from..to)
  end
end