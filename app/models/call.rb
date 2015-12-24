class Call < ActiveRecord::Base
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
