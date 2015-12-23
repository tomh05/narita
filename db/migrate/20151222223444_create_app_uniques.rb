class CreateAppUniques < ActiveRecord::Migration
  def change
    create_table :app_uniques do |t|
      t.datetime :event_time
      t.string :app_name
      t.string :username
      t.string :event_type

      t.timestamps null: false
    end
  end
end
