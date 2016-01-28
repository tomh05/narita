class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :load_participant_names
  protect_from_forgery with: :null_session

  def load_participant_names

    if params.has_key?(:selections)
      session[:p_username] = params[:selections]["username"]
    end


      @username = session[:p_username]

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
  end

end
