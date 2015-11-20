class CreateBrowsers < ActiveRecord::Migration
  def change
    create_table :browsers do |t|
      t.string :username
      t.string :title
      t.string :url

      t.timestamps null: false
    end
  end
end
