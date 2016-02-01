module ApplicationHelper

    def format_date current_date
      if current_date.nil?
        return "-"
      else
        return current_date.strftime("#{current_date.day.ordinalize} %b %Y, %H:%M:%S")
      end
    end

end
