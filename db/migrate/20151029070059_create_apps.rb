class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.datetime :event_time
      t.string :app_name

      t.timestamps null: false
    end
  end
end
