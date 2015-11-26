class PhotosController < ApplicationController
  
  require 'net/https'
  require 'open-uri'

  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.all
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(photo_params)

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url, notice: 'Photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    url = "https://s3-us-west-2.amazonaws.com/bbcirfs/coot/testing/"
    filename = params[:filename]+"."+params[:filetype]
    file = open(url+filename)
    image_exif = get_exif_data file
    @image = Photo.find_or_initialize_by(url: url+filename, username: params[:username])
    @image.width = image_exif['width'].to_s
    @image.height = image_exif['height'].to_s
    @image.model = image_exif['model'].to_s
    @image.photo_date = DateTime.parse(image_exif['date_time'].to_s)
    @image.photo_lat = image_exif['gps_latitude'].to_s
    @image.photo_long = image_exif['gps_longitude'].to_s
    @image.save
    @data = {'result' => 'Image imported'}
    render json: @data.as_json
  end

  def get_exif_data file
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:url)
    end
end
