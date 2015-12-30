class WelcomeController < ApplicationController
	before_action :authenticate_user!, :except => [:ping]

	def ping
	    @data = {'result' => 'Application is running'}
	    respond_to do |format|
	        format.json {render :json => @data.as_json}
	    end         
	end

end
