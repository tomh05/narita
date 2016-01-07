class FacebookMessagesController < ApplicationController
  before_action :set_facebook_message, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:import]

  # GET /facebook_messages
  # GET /facebook_messages.json
  def index
    @facebook_messages = FacebookMessage.all
  end

  # GET /facebook_messages/1
  # GET /facebook_messages/1.json
  def show
  end

  # GET /facebook_messages/new
  def new
    @facebook_message = FacebookMessage.new
  end

  # GET /facebook_messages/1/edit
  def edit
  end

  # POST /facebook_messages
  # POST /facebook_messages.json
  def create
    @facebook_message = FacebookMessage.new(facebook_message_params)

    respond_to do |format|
      if @facebook_message.save
        format.html { redirect_to @facebook_message, notice: 'Facebook message was successfully created.' }
        format.json { render :show, status: :created, location: @facebook_message }
      else
        format.html { render :new }
        format.json { render json: @facebook_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /facebook_messages/1
  # PATCH/PUT /facebook_messages/1.json
  def update
    respond_to do |format|
      if @facebook_message.update(facebook_message_params)
        format.html { redirect_to @facebook_message, notice: 'Facebook message was successfully updated.' }
        format.json { render :show, status: :ok, location: @facebook_message }
      else
        format.html { render :edit }
        format.json { render json: @facebook_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facebook_messages/1
  # DELETE /facebook_messages/1.json
  def destroy
    @facebook_message.destroy
    respond_to do |format|
      format.html { redirect_to facebook_messages_url, notice: 'Facebook message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import


    f = open("https://s3-us-west-2.amazonaws.com/bbcirfs/coot/logs/"+params[:filepath]+".csv");
    csv_text = f.read
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      parsed_message_date = DateTime.parse(row[6].to_s)
      @fb = FacebookMessage.find_or_initialize_by(fb_from: row[2].to_s, fb_content: URI.unescape(row[7].to_s), username: row[4].to_s)
      @fb.fb_date = parsed_message_date
      @fb.white_list = row[5].to_s
      @fb.sms_folder = row[3].to_s
      '''
    f = open(APP_CONFIG[server_path]+params[:filepath]+".csv");
    csv_text = f.read
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      parsed_message_date = DateTime.parse(row[4].to_s)
      @fb = FacebookMessage.find_or_initialize_by(fb_from: row[2].to_s, fb_content: URI.unescape(row[3].to_s), message_type: row[5].to_s,  username: row[7].to_s)
      @fb.fb_date = parsed_message_date
      @fb.stack_level = row[6].to_s
      '''
      @fb.save
    end

    @data = {'result' => 'Facebook messages imported'}
    respond_to do |format|
        format.json {render :json => @data.as_json}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facebook_message
      @facebook_message = FacebookMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def facebook_message_params
      params.require(:facebook_message).permit(:fb_date, :fb_content, :fb_from, :username)
    end
end
