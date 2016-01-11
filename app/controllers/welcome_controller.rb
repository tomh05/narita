class WelcomeController < ApplicationController
	before_action :authenticate_user!, :except => [:ping]

	def ping
	    @data = {'result' => APP_CONFIG['server_path']}
	    respond_to do |format|
	        format.json {render :json => @data.as_json}
	    end         
	end

end
