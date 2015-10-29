class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.datetime :event_time
      t.date :call_date
      t.string :call_number
      t.string :call_type
      t.string :call_duration

      t.timestamps null: false
    end
  end
end
