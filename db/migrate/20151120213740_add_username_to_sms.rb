class AddUsernameToSms < ActiveRecord::Migration

    def change
        add_column :sms_messages, :username, :string
    end

end
