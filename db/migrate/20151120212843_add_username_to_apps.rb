class AddUsernameToApps < ActiveRecord::Migration
    
    def change
        add_column :apps, :username, :string
    end

end
