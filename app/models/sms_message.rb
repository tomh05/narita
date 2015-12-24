class SmsMessage < ActiveRecord::Base
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
