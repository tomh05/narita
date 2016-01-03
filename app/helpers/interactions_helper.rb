module InteractionsHelper
    def roughtime(input_str)
        input = Integer(input_str)
        mm, ss = (input).divmod(60)            #=> [4515, 21]
        hh, mm = mm.divmod(60)           #=> [75, 15]
        dd, hh = hh.divmod(24)           #=> [3, 3]
        if input < 60
            return String(ss) +  " seconds"
        elsif input < 3600
            return String(mm) + " minutes"
        elsif input < 3600*2
            return String(hh) + " hour " +  String(mm) + " minutes"
        elsif input < 3600*24
            return String(hh) + " hours " +  String(mm) + " minutes"
        else
            return String(dd) + " days " + String(hh)  + " hours " +  String(mm) + " minutes"
        end

    end
end
