class AddEventTimeToBrowser < ActiveRecord::Migration

    def change
        add_column :browsers, :event_time, :datetime
    end

end
