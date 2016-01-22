class TimelineController < ApplicationController
  def index
    #Calls
    # Gather together into timeline events
    if params.has_key?(:selections)
      @username = params[:selections]["username"]
    end

    @calls = Call.username(@username)
    @sms_messages = SmsMessage.username(@username)

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
      @app_uniques = @app_uniques.daterange(fromdate,todate)
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
      if sms.sms_folder == "sent"
        newTimeline.direction = "outgoing"
      else
        newTimeline.direction = "incoming"
      end
      @Timelines << newTimeline
    end

    last_time = DateTime.new(1970,1,1)
    last_app = ""
    @app_uniques.each do |app_unique|
      unless app_unique.priority.nil?
        next if (app_unique.priority < 2)
      end
      time_diff = ((app_unique.event_time - last_time) * 24 * 60 * 60).to_i # mins
      puts "time " + time_diff.to_s
      if (last_app != app_unique.app_name and time_diff>30 )
        last_app = app_unique.app_name
        last_time = app_unique.event_time
      newTimeline = Timeline.new;
      newTimeline.type = "app_unique"
      newTimeline.datetime = app_unique.event_time
      if app_unique.shortname.present?
        newTimeline.content = app_unique.shortname
      else
        newTimeline.content = app_unique.app_name
      end
      @Timelines << newTimeline
    end
    end
    @Timelines.sort! { |a,b| a.datetime <=> b.datetime}
  end
end
