class AppUnique < ActiveRecord::Base
    def self.username(name)
        where(username: name)
    end
    def self.daterange(from,to)
        where(event_time: from..to)
    end
end
