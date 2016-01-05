class InteractionsController < ApplicationController
  def index
    if params.has_key?(:selections)
      @username = params[:selections]["username"]
      @interactee = params[:selections]["interactee"]
    end


    @usernames = Call.select("DISTINCT username").union(SmsMessage.select("DISTINCT username"))

    @usernames = @usernames.joins("LEFT JOIN people ON calls.username = people.google")
    @usernames = @usernames.select("username,CONCAT(people.first_name,' ',people.last_name) as name")



    @interactees = Call.username(@username).select("DISTINCT call_number AS number").union(SmsMessage.username(@username).select("DISTINCT sms_sender as number"))
    @interactees = @interactees.joins("LEFT JOIN people ON calls.number LIKE CONCAT('%',people.phone)")
    @interactees = @interactees.select("calls.*,CONCAT(people.first_name,' ',people.last_name) as name")
    @interactees.each do |i|
      unless i.name.present?
        i.name = i.number
      end
    end

    @calls = Call.username(@username).number(@interactee)
    @sms_messages = SmsMessage.username(@username).number(@interactee)

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
        if sms.sms_folder == "sent"
          newInteraction.direction = "outgoing"
        else
          newInteraction.direction = "incoming"
        end

        @interactions << newInteraction
      end

      @interactions.sort! { |a,b| a.datetime <=> b.datetime}

  end
end
