class ScreensController < ApplicationController
  before_action :set_screen, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:import]

  # GET /screens
  # GET /screens.json
  def index
    if @username.nil? || @username.empty?
      @screens = Screen.all
    else
      @screens = Screen.username(@username)
    end
    @screens = @screens.order(:event_time)
    respond_to do |format|
    format.html
    format.csv { send_data @screens.as_csv }
  end
  end

  # GET /screens/1
  # GET /screens/1.json
  def show
  end

  # GET /screens/new
  def new
    @screen = Screen.new
  end

  # GET /screens/1/edit
  def edit
  end

  # POST /screens
  # POST /screens.json
  def create
    @screen = Screen.new(screen_params)

    respond_to do |format|
      if @screen.save
        format.html { redirect_to @screen, notice: 'Screen was successfully created.' }
        format.json { render :show, status: :created, location: @screen }
      else
        format.html { render :new }
        format.json { render json: @screen.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /screens/1
  # PATCH/PUT /screens/1.json
  def update
    respond_to do |format|
      if @screen.update(screen_params)
        format.html { redirect_to @screen, notice: 'Screen was successfully updated.' }
        format.json { render :show, status: :ok, location: @screen }
      else
        format.html { render :edit }
        format.json { render json: @screen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /screens/1
  # DELETE /screens/1.json
  def destroy
    @screen.destroy
    respond_to do |format|
      format.html { redirect_to screens_url, notice: 'Screen was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def import
    f = open(APP_CONFIG['server_path']+params[:filepath]+".csv");
    csv_text = f.read
    Screen.import(csv_text)

    @data = {'result' => 'Screen events imported'}
    respond_to do |format|
        format.json {render :json => @data.as_json}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_screen
      @screen = Screen.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def screen_params
      params.require(:screen).permit(:event_time, :event_type, :username)
    end
end
