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
  end
end
