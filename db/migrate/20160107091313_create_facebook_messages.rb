class CreateFacebookMessages < ActiveRecord::Migration
  def change
    create_table :facebook_messages do |t|
      t.datetime :fb_date
      t.string :fb_content
      t.string :fb_from
      t.string :username

      t.timestamps null: false
    end
  end
end
