class Photo < ActiveRecord::Base
  def self.import(filename, username)
    file = open(filename)
    image_exif = get_exif_data file
    file_name = File.basename(filename)
    @image = Photo.find_or_initialize_by(url: file_name, username: username)
    @image.width = image_exif['width'].to_s
    @image.height = image_exif['height'].to_s
    @image.model = image_exif['model'].to_s
    @image.photo_date = DateTime.parse(image_exif['date_time'].to_s)
    @image.photo_lat = image_exif['gps_latitude'].to_s
    @image.photo_long = image_exif['gps_longitude'].to_s
    @image.save
  end


  def self.get_exif_data(file)
    image_exif = EXIFR::JPEG.new(file)
    begin
      width = image_exif.width
    rescue Exception => e
      width = ""
    end
    begin
      height = image_exif.height
    rescue Exception => e
      height = ""
    end
    begin
      date_time = image_exif.date_time
    rescue Exception => e
      date_time = ""
    end
    begin
      model = image_exif.model
    rescue Exception => e
      model = ""
    end
    begin
      gps_latitude = image_exif.gps.latitude
    rescue Exception => e
      gps_latitude = ""
    end
    begin
      gps_longitude = image_exif.gps.longitude
    rescue Exception => e
      gps_longitude = ""
    end
    data = Hash.new
    data = { "width" => width, "height" => height, "date_time" => date_time,
      "model" => model, "gps_latitude" => gps_latitude, "gps_longitude" => gps_longitude   }
    data
  end

end