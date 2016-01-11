class AppUniquesController < ApplicationController
  before_action :set_app_unique, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:import]

  # GET /app_uniques
  # GET /app_uniques.json
  def index
    @app_uniques = AppUnique.all
  end

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
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      parsed_event_time = DateTime.parse(row[0].to_s+'_'+row[1].to_s)
      @app = AppUnique.find_or_initialize_by(event_time: parsed_event_time, app_name: row[2].to_s, username: row[3].to_s)
      @app.save
    end

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
