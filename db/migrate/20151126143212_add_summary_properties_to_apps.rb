class AddSummaryPropertiesToApps < ActiveRecord::Migration

    def change
        add_column :apps, :event_type, :string
        add_column :apps, :last_used, :datetime
        add_column :apps, :total_use, :string
    end

end
