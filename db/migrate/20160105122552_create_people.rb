class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :alt_phone
      t.string :google
      t.string :facebook
      t.string :twitter
      t.boolean :whitelist
      t.string :image
      t.integer :gender
      t.text :notes

      t.timestamps null: false
    end
  end
end
