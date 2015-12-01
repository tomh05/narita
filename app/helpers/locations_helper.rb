module LocationsHelper

    def format_date(current_date)
      return current_date.strftime("#{current_date.day.ordinalize} %b %Y, %H:%M")
      # return current_date.strftime("%e %b %Y, %H:%M")
    end

end
