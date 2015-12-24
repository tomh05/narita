class CreateSims < ActiveRecord::Migration
  def change
    create_table :sims do |t|
      t.datetime :event_time
      t.string :event_type
      t.string :username

      t.timestamps null: false
    end
  end
end
