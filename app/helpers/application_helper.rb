module ApplicationHelper

    def format_date current_date
      return current_date.strftime("#{current_date.day.ordinalize} %b %Y, %H:%M")
    end
    
end
