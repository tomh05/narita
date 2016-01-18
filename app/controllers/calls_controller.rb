class CallsController < ApplicationController
  require 'net/https'
  require 'open-uri'
  require 'csv'

  before_action :set_call, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:import]
  # GET /calls
  # GET /calls.json
  def index
    #@calls = Call.all
    if params.has_key?(:call)
      @username = params[:call]["username"]
    end

    if @username.nil? || @username.empty?
      @calls = Call.all
    else
      @calls = Call.username(@username)
    end
    #if not params["fromdate"].nil?
    begin
      fromdate = Date.strptime(params["fromdate"],"%d/%m/%Y %H:%M")
      todate = Date.strptime(params["todate"],"%d/%m/%Y %H:%M")
    rescue
    puts "invalid date"
    else
      @fromdate_str = params["fromdate"]
      @todate_str = params["todate"]
      @calls = @calls.daterange(fromdate,todate)
    end


    # Replace numbers and usernames with real names
    @calls_display = @calls.joins("LEFT JOIN people AS people_other ON calls.call_number LIKE CONCAT('%',people_other.phone)")#.select("calls.*,people.first_name,people.last_name").order('event_time ASC')
    @calls_display = @calls_display.joins("LEFT JOIN people AS people_self ON calls.username = people_self.google")
    @calls_display = @calls_display.select("calls.*,people_other.first_name as other_first_name,people_other.last_name as other_last_name, people_other.id as other_id, people_self.first_name as own_first_name, people_self.last_name as own_last_name")
    @calls_display = @calls_display.order('event_time ASC')

    @usernames = Call.select("DISTINCT username")
    @usernames = @usernames.joins("LEFT JOIN people ON calls.username = people.google")
    @usernames = @usernames.select("CONCAT(people.first_name,' ',people.last_name) as name")


    @stats = Array.new


    puts Call.column_names


    unless @username.nil? || @username.empty?
      @stats.push({value: @calls.count, desc: "$ total call events logged"});
      @stats.push({value: @calls.where(call_type: "OUTGOING").count, desc: "They made $ outgoing calls"});
      @stats.push({value: @calls.where(call_type: "INCOMING").count, desc: "They received $ incoming calls"});
      @stats.push({value: @calls.where(call_type: "MISSED").count, desc: "They missed $ calls"});

      #unique_all = @calls.select("call_number").distinct.count
      #@stats.push({value: unique_all, desc: " $ people interacted via calls with this person"});

      unique_in = @calls.where(call_type: "INCOMING").select("call_number").distinct.count
      @stats.push({value: unique_in, desc: " $ different people called them"});

      unique_out = @calls.where(call_type: "OUTGOING").select("call_number").distinct.count
      @stats.push({value: unique_out, desc: "This person called $ different people."});


      call_time_secs = @calls.sum("call_duration::integer");
      mm, ss = call_time_secs.divmod(60)            #=> [4515, 21]
      hh, mm = mm.divmod(60)           #=> [75, 15]
      dd, hh = hh.divmod(24)           #=> [3, 3]
      total_time = dd.to_s + ", "+ hh.to_s.rjust(2,'0') +":"+ mm.to_s.rjust(2,'0')
      @stats.push({value: total_time, desc: "Total call time $ days, hours:mins"});

      longest_secs = @calls.maximum("call_duration::integer").to_i;
      puts longest_secs
      mm, ss = longest_secs.divmod(60)            #=> [4515, 21]
      hh, mm = mm.divmod(60)           #=> [75, 15]
      longest_call = hh.to_s + ":" + mm.to_s.rjust(2,'0')
      @stats.push({value: longest_call, desc: "Longest call $ hours:mins"});

      @total_distinct_outgoing = Call.where(call_type: "OUTGOING").distinct.count

    end
  end

  # GET /calls/1
  # GET /calls/1.jso:wasn
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
    f = open(APP_CONFIG['server_path']+params[:filepath]+".csv");
    csv_text = f.read
    Call.import(csv_text)

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
