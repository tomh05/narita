class AddExifToPhotos < ActiveRecord::Migration
    
    def change
        add_column :photos, :width, :string
        add_column :photos, :height, :string
        add_column :photos, :model, :string
        add_column :photos, :photo_date, :datetime
        add_column :photos, :photo_lat, :string
        add_column :photos, :photo_long, :string
    end

end
