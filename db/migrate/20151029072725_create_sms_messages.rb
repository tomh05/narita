class CreateSmsMessages < ActiveRecord::Migration
  def change
    create_table :sms_messages do |t|
      t.datetime :event_time
      t.text :sms_content
      t.string :sms_sender

      t.timestamps null: false
    end
  end
end
