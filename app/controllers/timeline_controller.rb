require 'identicon'
class TimelineController < ApplicationController
  def index
    #Calls
    # Gather together into timeline events

    if params.has_key?(:options)
      session[:options] = params[:options]
    end

    if session[:options].nil?
      @options = {:calls =>"1",
        :sms_messages =>"1",
        :whatsapp =>"1",
        :facebook =>"1",
        :screens =>"1",
        :apps =>"1",
        :browsers =>"1"
      }
    else
      @options = session[:options]
    end

    @backup_usernames = Backup.joins("LEFT JOIN people ON backups.username = people.google").select("people.first_name,people.last_name,backups.username")


    @calls = Call.joins("LEFT JOIN people ON calls.call_number = people.phone").select("calls.*,people.first_name,people.last_name")
    @calls = @calls.username(@username)
    @sms_messages = SmsMessage.joins("LEFT JOIN people ON sms_messages.sms_sender = people.phone").select("sms_messages.*,people.first_name,people.last_name")
    @sms_messages = @sms_messages.username(@username)
    @facebook_messages = FacebookMessage.username(@username)
    @whatsapp_messages = WhatsappMessage.username(@username)
    @screens = Screen.username(@username)
    @browsers = Browser.username(@username)

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
      @facebook_messages = @facefacebook_messages.daterange(fromdate,todate)
      @whatsapp_messages = @whatwhatsapp_messages.daterange(fromdate,todate)
      @browsers = @browsers.daterange(fromdate,todate)
    end

    @Timelines = []

    if (@options[:calls] == "1")
      @calls.each do |call|
        newTimeline = Timeline.new;
        newTimeline.type = "call"
        newTimeline.datetime = call.event_time
        newTimeline.duration = call.call_duration
        if call.first_name.present?
            newTimeline.other = call.first_name + " " + call.last_name
          else
            newTimeline.other = call.call_number
        end
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
    end

    if (@options[:sms_messages] == "1")
      @sms_messages.each do |sms|
        newTimeline = Timeline.new;
        newTimeline.type = "sms"
        newTimeline.datetime = sms.sms_date
        newTimeline.content = sms.sms_content
        if sms.first_name.present?
            newTimeline.other = sms.first_name + " " + sms.last_name
          else
            newTimeline.other = sms.sms_sender
        end
        if sms.sms_folder == "sent"
          newTimeline.direction = "outgoing"
        else
          newTimeline.direction = "incoming"
        end
        @Timelines << newTimeline
      end
    end


    if (@options[:whatsapp] == "1")
      @whatsapp_messages.each do |whatsapp|
        newTimeline = Timeline.new;
        newTimeline.type = "whatsapp"
        newTimeline.datetime = whatsapp.wa_date
        newTimeline.other = whatsapp.wa_from
        newTimeline.content = whatsapp.wa_content
        if whatsapp.message_type == "sent"
          newTimeline.direction = "outgoing"
        else
          newTimeline.direction = "incoming"
        end
        @Timelines << newTimeline
      end
    end

    if (@options[:facebook]== "1")
      @facebook_messages.each do |facebook|
        newTimeline = Timeline.new;
        newTimeline.type = "facebook"
        newTimeline.datetime = facebook.fb_date
        newTimeline.content = facebook.fb_content
        newTimeline.other = facebook.fb_from
        if facebook.message_type == "sent"
          newTimeline.direction = "outgoing"
        else
          newTimeline.direction = "incoming"
        end
        @Timelines << newTimeline
      end
    end

    if (@options[:apps]== "1")
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
    end

    if (@options[:screens]== "1")
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
    end

    if (@options[:browsers]== "1")
      @browsers.each do |browser|
          newTimeline = Timeline.new;
          newTimeline.type = "browser"
          newTimeline.datetime = browser.visit_date
          newTimeline.content = browser.title
          newTimeline.other = browser.url
          @Timelines << newTimeline
        #end
      end
    end


    @Timelines.sort! { |a,b| a.datetime <=> b.datetime}
  end
end
