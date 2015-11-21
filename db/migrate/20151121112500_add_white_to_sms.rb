class AddWhiteToSms < ActiveRecord::Migration

    def change
        add_column :sms_messages, :white_list, :string
    end

end
