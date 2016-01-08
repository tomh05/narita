class AddStackLevelToFbMessages < ActiveRecord::Migration

	def change
  		add_column :facebook_messages, :stack_level, :integer
  	end

end
