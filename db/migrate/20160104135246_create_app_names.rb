class CreateAppNames < ActiveRecord::Migration
  def change
    create_table :app_names do |t|
      t.string :longname
      t.string :shortname
      t.string :color
      t.integer :priority

      t.timestamps null: false
    end
  end
end
