class Timeline < ActiveRecord::Base
    attr_accessor :type, :datetime, :content, :duration, :direction, :missed, :color, :other
end
