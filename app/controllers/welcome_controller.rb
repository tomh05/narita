class WelcomeController < ApplicationController

	def index
  		# render :file => 'public/index.html'
  		# format.html

	    respond_to do |format|
	        format.html {}
	    end

	end

end
