class TimelineController < ApplicationController
  def index
    #Calls
    # Gather together into timeline events
    if params.has_key?(:selections)
      @username = params[:selections]["username"]
    end

    @backup_usernames = Backup.joins("LEFT JOIN people ON backups.username = people.google").select("people.first_name,people.last_name,backups.username")
    @usernames = Hash.new
    @backup_usernames.each do |i|
        if i.first_name.present?
          #newUsername[i.first_name + " " + i.last_name] = i.first_name + " " + i.last_name
          @usernames[i.first_name + " " + i.last_name] = i.username
        else
          #newUsername[:displayname] = i.username
          @usernames[i.username] = i.username
        end
      end
    #@usernames = @usernames.map(&:username).uniq

    @calls = Call.username(@username)
    @sms_messages = SmsMessage.username(@username)
    @facebook_messages = FacebookMessage.username(@username)
    @whatsapp_messages = WhatsappMessage.username(@username)
    @screens = Screen.username(@username)

    #App uniques
    @app_uniques = AppUnique.joins("LEFT JOIN app_names ON app_uniques.app_name = app_names.longname").select("app_uniques.*,app_names.shortname,app_names.color,app_names.priority").order('event_time ASC')
    @app_uniques = @app_uniques.username(@username)


    # Filter by date
    begin
      fromdate = Date.strptime(params["fromdate"],"%d/%m/%Y %H:%M")
      todate = Date.strptime(params["todate"],"%d/%m/%Y %H:%M")

    rescue
    puts "invalid date"
    else
      @fromdate_str = params["fromdate"]
      @todate_str = params["todate"]
      @calls = @calls.daterange(fromdate,todate)
      @sms_messages = @sms_messages.daterange(fromdate,todate)
      @app_uniques = @app_uniques.daterange(fromdate,todate)
      @screens = @screens.daterange(fromdate,todate)
    end

    @Timelines = []

    @calls.each do |call|
      newTimeline = Timeline.new;
      newTimeline.type = "call"
      newTimeline.datetime = call.event_time
      newTimeline.duration = call.call_duration
      if call.call_type == "OUTGOING"
        newTimeline.direction = "outgoing"
      else
        newTimeline.direction = "incoming"
      end
      if call.call_type == "missed"
        newTimeline.missed = true
      end
      @Timelines << newTimeline
    end

    @sms_messages.each do |sms|
      newTimeline = Timeline.new;
      newTimeline.type = "sms"
      newTimeline.datetime = sms.sms_date
      newTimeline.content = sms.sms_content
      newTimeline.other = sms.sms_sender
      if sms.sms_folder == "sent"
        newTimeline.direction = "outgoing"
      else
        newTimeline.direction = "incoming"
      end
      @Timelines << newTimeline
    end

    @whatsapp_messages.each do |whatsapp|
      newTimeline = Timeline.new;
      newTimeline.type = "whatsapp"
      newTimeline.datetime = whatsapp.wa_date
      newTimeline.other = whatsapp.wa_from
      newTimeline.content = whatsapp.wa_content
      if whatsapp.message_type == "OUTGOING"
        newTimeline.direction = "outgoing"
      else
        newTimeline.direction = "incoming"
      end
      @Timelines << newTimeline
    end

    @facebook_messages.each do |facebook|
      newTimeline = Timeline.new;
      newTimeline.type = "facebook"
      newTimeline.datetime = facebook.fb_date
      newTimeline.content = facebook.fb_content
      newTimeline.other = facebook.fb_from
      if facebook.fb_message_type == "OUTGOING"
        newTimeline.direction = "outgoing"
      else
        newTimeline.direction = "incoming"
      end
      @Timelines << newTimeline
    end

    last_app_time = DateTime.new(1970,1,1)
    last_app = ""
    @app_uniques.each do |app_unique|
      unless app_unique.priority.nil?
        next if (app_unique.priority < 2)
      end
      time_diff = ((app_unique.event_time - last_app_time) * 24 * 60 * 60).to_i # mins
      if (last_app != app_unique.app_name and time_diff>30 )
        last_app = app_unique.app_name
        last_app_time = app_unique.event_time
        newTimeline = Timeline.new;
        newTimeline.type = "app_unique"
        newTimeline.datetime = app_unique.event_time
        if app_unique.shortname.present?
          newTimeline.color = app_unique.color
        else
          newTimeline.color = "999"
        end
        if app_unique.shortname.present?
          newTimeline.content = app_unique.shortname
        else
          newTimeline.content = app_unique.app_name
        end
        @Timelines << newTimeline
      end
    end

    last_screen_time = DateTime.new(1970,1,1)
    last_screen = ""
    @screens.each do |screen|
      #time_diff = ((screen.event_time - last_screen_time) * 24 * 60 * 60).to_i # mins
      #puts "time " + time_diff.to_s
      #if (last_screen != screen.app_name and time_diff>30 )
        last_screen = screen.event_type
        last_screen_time = screen.event_time
        newTimeline = Timeline.new;
        newTimeline.type = "screen"
        newTimeline.datetime = screen.event_time
        newTimeline.content = screen.event_type
        @Timelines << newTimeline
      #end
    end


    @Timelines.sort! { |a,b| a.datetime <=> b.datetime}
  end
end
