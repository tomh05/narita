module LocationsHelper

    # def format_date current_date
    #   return current_date.strftime("#{current_date.day.ordinalize} %b %Y, %H:%M")
    # end

    def get_map_url lat, long
        return "https://www.google.com/maps?q="+lat+","+long
    end

end
