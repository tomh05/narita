class CreateBackups < ActiveRecord::Migration
  def change
    create_table :backups do |t|
      t.datetime :started
      t.datetime :ended
      t.string :username
      t.string :ref

      t.timestamps null: false
    end
  end
end
