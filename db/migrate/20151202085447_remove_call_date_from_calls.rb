class RemoveCallDateFromCalls < ActiveRecord::Migration

    def change
        remove_column :calls, :call_date
    end

end
