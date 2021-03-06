class FacebookMessagesController < ApplicationController
  before_action :set_facebook_message, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:import]

  # GET /facebook_messages
  # GET /facebook_messages.json
  def index
    if @username.nil? || @username.empty?
      @facebook_messages = FacebookMessage.all
    else
      @facebook_messages = FacebookMessage.username(@username)
    end
    respond_to do |format|
    format.html
    format.csv { send_data @facebook_messages.as_csv }
  end
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
    FacebookMessage.import(csv_text)

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
