class Person < ActiveRecord::Base
    def self.username(name)
    where(google: name)
  end
end
