module LocationsHelper

    def get_map_url lat, long
        return "https://www.google.com/maps?q="+lat+","+long
    end

end
