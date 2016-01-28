class SimsController < ApplicationController
  before_action :set_sim, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:import]

  # GET /sims
  # GET /sims.json
  def index
    if @username.nil? || @username.empty?
      @sims = Sim.all
    else
      @sims = Sim.username(@username)
    end
  end

  # GET /sims/1
  # GET /sims/1.json
  def show
  end

  # GET /sims/new
  def new
    @sim = Sim.new
  end

  # GET /sims/1/edit
  def edit
  end

  # POST /sims
  # POST /sims.json
  def create
    @sim = Sim.new(sim_params)

    respond_to do |format|
      if @sim.save
        format.html { redirect_to @sim, notice: 'Sim was successfully created.' }
        format.json { render :show, status: :created, location: @sim }
      else
        format.html { render :new }
        format.json { render json: @sim.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sims/1
  # PATCH/PUT /sims/1.json
  def update
    respond_to do |format|
      if @sim.update(sim_params)
        format.html { redirect_to @sim, notice: 'Sim was successfully updated.' }
        format.json { render :show, status: :ok, location: @sim }
      else
        format.html { render :edit }
        format.json { render json: @sim.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sims/1
  # DELETE /sims/1.json
  def destroy
    @sim.destroy
    respond_to do |format|
      format.html { redirect_to sims_url, notice: 'Sim was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    f = open(APP_CONFIG['server_path']+params[:filepath]+".csv");
    csv_text = f.read
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      parsed_event_time = DateTime.parse(row[0].to_s+'_'+row[1].to_s)
      @app = Sim.find_or_initialize_by(event_time: parsed_event_time, event_type: row[2].to_s, username: row[3].to_s)
      @app.save
    end

    @data = {'result' => 'Sim events imported'}
    respond_to do |format|
        format.json {render :json => @data.as_json}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sim
      @sim = Sim.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sim_params
      params.require(:sim).permit(:event_time, :event_type, :username)
    end
end
