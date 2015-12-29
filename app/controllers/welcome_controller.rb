class WelcomeController < ApplicationController

	def index
  		# render :file => 'public/index.html'
  		# format.html

		render template: "welcome/index"

	end

end
