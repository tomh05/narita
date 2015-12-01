module LocationsHelper

    def format_date(current_date)
      # return current_date.strftime("{%e.ordinalize} %b %Y, %H:%M")
      return current_date.strftime("%e %b %Y, %H:%M")
    end

end
