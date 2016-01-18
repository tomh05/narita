class AppUniquesController < ApplicationController
  before_action :set_app_unique, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:import]

  # GET /app_uniques
  # GET /app_uniques.json
  def index
    @app_uniques = AppUnique.joins("LEFT JOIN app_names ON app_uniques.app_name = app_names.longname").select("app_uniques.*,app_names.shortname,app_names.color,app_names.priority").order('event_time ASC')

    @usernames = AppUnique.select("DISTINCT username")
    begin
      fromdate = DateTime.strptime(params["fromdate"],"%d/%m/%Y %H:%M")
      todate = DateTime.strptime(params["todate"],"%d/%m/%Y %H:%M")
      puts fromdate
      @app_uniques = @app_uniques.daterange(fromdate,todate)
    rescue
    puts "invalid date"
    else
      @fromdate_str = params["fromdate"]
      @todate_str = params["todate"]
    end


    @app_timeline_data = []
    @app_uniques.each do |entry|
      unless entry.priority.nil?
        next if (entry.priority < 2)
      end
      if entry.shortname.present?
        name = entry.shortname
      else
        name = entry.app_name
      end
      # ignore close consecutive app logs
      if ((not @app_timeline_data.empty?) and (@app_timeline_data.last[0] == name) and (entry.event_time - @app_timeline_data.last[2]< 60))

        #puts "diff"
        #puts entry.event_time - @app_timeline_data.last[2]
        @app_timeline_data.last[2] = entry.event_time
        #puts "extending time of " + name
      else
        #puts "adding "+name
        @app_timeline_data << [name, entry.event_time, entry.event_time]
      end
    end
  end
  puts @app_timeline_data

  # GET /app_uniques/1
  # GET /app_uniques/1.json
  def show
  end

  # GET /app_uniques/new
  def new
    @app_unique = AppUnique.new
  end

  # GET /app_uniques/1/edit
  def edit
  end

  # POST /app_uniques
  # POST /app_uniques.json
  def create
    @app_unique = AppUnique.new(app_unique_params)

    respond_to do |format|
      if @app_unique.save
        format.html { redirect_to @app_unique, notice: 'App unique was successfully created.' }
        format.json { render :show, status: :created, location: @app_unique }
      else
        format.html { render :new }
        format.json { render json: @app_unique.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_uniques/1
  # PATCH/PUT /app_uniques/1.json
  def update
    respond_to do |format|
      if @app_unique.update(app_unique_params)
        format.html { redirect_to @app_unique, notice: 'App unique was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_unique }
      else
        format.html { render :edit }
        format.json { render json: @app_unique.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_uniques/1
  # DELETE /app_uniques/1.json
  def destroy
    @app_unique.destroy
    respond_to do |format|
      format.html { redirect_to app_uniques_url, notice: 'App unique was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    f = open(APP_CONFIG['server_path']+params[:filepath]+".csv");
    csv_text = f.read
    AppUnique.import(csv_text)

    @data = {'result' => 'Apps imported'}
    respond_to do |format|
        format.json {render :json => @data.as_json}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_unique
      @app_unique = AppUnique.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_unique_params
      params.require(:app_unique).permit(:event_time, :app_name, :username, :event_type)
    end
end
