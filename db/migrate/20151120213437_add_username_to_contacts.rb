class AddUsernameToContacts < ActiveRecord::Migration

    def change
        add_column :contacts, :username, :string
    end

end
