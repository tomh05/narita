class InteractionsController < ApplicationController
  def index
    if params.has_key?(:selections)
      @username = params[:selections]["username"]
      @number = params[:selections]["number"]
    end


    @usernames = Call.select("DISTINCT username").union(SmsMessage.select("DISTINCT username"))
    @numbers = Call.username(@username).select("DISTINCT call_number AS number").union(SmsMessage.username(@username).select("DISTINCT sms_sender as number"))
    @calls = Call.username(@username).number(@number)

    @sms_messages = SmsMessage.username(@username).number(@number)

    #sql = Call.connection.unprepared_statement {  "((#{@calls.to_sql}) UNION (#{@sms_messages.to_sql})) AS items"}
    #Call.from(sql).order("ASC")

    @all_interactions = @calls + @sms_messages
    puts "here are all:"
    @all_interactions.each do |alli|
      puts alli
    end

      @interactions = []

      @calls.each do |call|
        newInteraction = Interaction.new;
        newInteraction.type = "call"
        newInteraction.datetime = call.event_time
        newInteraction.duration = call.call_duration
        if call.call_type == "OUTGOING"
          newInteraction.direction = "outgoing"
        else
          newInteraction.direction = "incoming"
        end

        if call.call_type == "missed"
          newInteraction.missed = true
        end
        @interactions << newInteraction
      end


      @sms_messages.each do |sms|
        newInteraction = Interaction.new;
        newInteraction.type = "sms"
        newInteraction.datetime = sms.sms_date
        newInteraction.content = sms.sms_content
        @interactions << newInteraction
      end

      @interactions.sort! { |a,b| a.datetime <=> b.datetime}

  end
end
