class AddSmsFolderToSmsMessages < ActiveRecord::Migration
    
    def change
        rename_column :sms_messages, :event_time, :sms_date
        add_column :sms_messages, :sms_folder, :string
    end

end
