class AddTypeToFacebookMessages < ActiveRecord::Migration

	def change
  		add_column :facebook_messages, :message_type, :string
  	end

end
