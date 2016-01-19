class CreateWhatsappMessages < ActiveRecord::Migration
  def change
    create_table :whatsapp_messages do |t|
      t.datetime :wa_date
      t.string :wa_content
      t.string :wa_from
      t.string :username
      t.string :message_type
      t.integer :stack_level

      t.timestamps null: false
    end
  end
end
