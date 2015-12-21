class CallsController < ApplicationController
  before_action :set_call, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:import]
  # GET /calls
  # GET /calls.json
  def index
    @calls = Call.all
  end

  # GET /calls/1
  # GET /calls/1.json
  def show
  end

  # GET /calls/new
  def new
    @call = Call.new
  end

  # GET /calls/1/edit
  def edit
  end

  # POST /calls
  # POST /calls.json
  def create
    @call = Call.new(call_params)

    respond_to do |format|
      if @call.save
        format.html { redirect_to @call, notice: 'Call was successfully created.' }
        format.json { render :show, status: :created, location: @call }
      else
        format.html { render :new }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calls/1
  # PATCH/PUT /calls/1.json
  def update
    respond_to do |format|
      if @call.update(call_params)
        format.html { redirect_to @call, notice: 'Call was successfully updated.' }
        format.json { render :show, status: :ok, location: @call }
      else
        format.html { render :edit }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calls/1
  # DELETE /calls/1.json
  def destroy
    @call.destroy
    respond_to do |format|
      format.html { redirect_to calls_url, notice: 'Call was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    f = open("https://s3-us-west-2.amazonaws.com/bbcirfs/coot/logs/"+params[:filepath]+".csv");
    csv_text = f.read
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      @contact = Call.find_or_initialize_by(event_time: DateTime.parse(row[2].to_s), call_number: row[3], call_type: row[4], call_duration: row[5], username: row[6].to_s)
      @contact.save
    end

    @data = {'result' => 'Calls imported'}
    respond_to do |format|
        format.json {render :json => @data.as_json}
    end   
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_call
      @call = Call.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def call_params
      params.require(:call).permit(:event_time, :call_date, :call_number, :call_type, :call_duration)
    end
end
