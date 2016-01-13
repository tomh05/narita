class InteractionsController < ApplicationController
  def index
    if params.has_key?(:selections)
      @username = params[:selections]["username"]
      @interactee = params[:selections]["interactee"]
    end

    if params.has_key?(:interactee)
      @interactee = params["interactee"]
    end

    @usernames = Call.select("DISTINCT username").union(SmsMessage.select("DISTINCT username"))

    @usernames = @usernames.joins("LEFT JOIN people ON calls.username = people.google")
    @usernames = @usernames.select("username,CONCAT(people.first_name,' ',people.last_name) as name")


    # look for all people that could be interacted with
    # get sms numbers, convert to userid
    '''
    sms_interactees = SmsMessage.select("DISTINCT sms_sender")
    sms_interactees = sms_interactees.joins("LEFT JOIN people ON sms_sender LIKE CONCAT('%',people.phone)")
    sms_interactees = sms_interactees.select("sms_sender as value, CONCAT(people.first_name,' ',people.last_name) as name")
    sms_interactees.each do |i|
      if i.name.present?
      i.value = i.name
    end
    puts i.name + ": " + i.value
    end
    # get call numbers, convert to userid
    # make userids distinct
    '''


    if @username.present?
      puts "username is " + @username
      @interactees = Call.username(@username).select("DISTINCT call_number AS number").union(SmsMessage.username(@username).select("DISTINCT sms_sender as number"))
      @interactees = @interactees.joins("LEFT JOIN people ON calls.number LIKE CONCAT('%',people.phone)")
      @interactees = @interactees.select("calls.*,CONCAT(people.first_name,' ',people.last_name) as name")
      @interactees.each do |i|
        unless i.name.present?
          i.name = i.number
        end
      end
      @interactees = @interactees.map(&:name).uniq
    else
      @interactees = ["Select a username and press submi  t first"]
    end


    if @interactee.present?
      # select the results for the interactee we have
      #puts  Person.select("*,CONCAT(first_name,' ',last_name) as name").where(name: @interactee)
      person = Person.all.where("CONCAT(first_name,' ',last_name) = '"+@interactee+"'").first
      if person.present?
        # we found a recognised user - search all databases for their interactions
        if (person.phone.present?)
          phone_wildcard = '%'+person.phone
          @calls = Call.username(@username).where("call_number LIKE '"+phone_wildcard+"'")
          @sms_messages = SmsMessage.username(@username).where("sms_sender LIKE '"+phone_wildcard+"'")
        end
        #if (person.alt_phone.present?)
        # alt_phone_wildcard = '%'+person.phone
        #  #@calls = @calls.or("call_number LIKE "+alt_phone_wildcard)
        #end
        #@calls = Call.username(@username).where("call_number LIKE CONCAT('%',"+person.phone+") OR call_number LIKE CONCAT('%',"+person.alt_phone+")")

        #@calls = Call.username(@username).where("number LIKE CONCAT('%',"+person.phone+") or number LIKE CONCAT('%',"+person.alt_phone+")")
        @sms_messages = SmsMessage.username(@username).number(@interactee)
      else
      @calls = Call.username(@username).number(@interactee)
      @sms_messages = SmsMessage.username(@username).number(@interactee)
      end
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
  else
    @interactions = []
  end
end
end