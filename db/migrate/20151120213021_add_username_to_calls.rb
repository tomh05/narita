class AddUsernameToCalls < ActiveRecord::Migration

    def change
        add_column :calls, :username, :string
    end

end
