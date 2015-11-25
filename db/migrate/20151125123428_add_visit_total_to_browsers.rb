class AddVisitTotalToBrowsers < ActiveRecord::Migration

    def change
        rename_column :browsers, :event_time, :visit_date
        add_column :browsers, :visit_total, :integer
    end

end
