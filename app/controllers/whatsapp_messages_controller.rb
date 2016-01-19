class WhatsappMessagesController < ApplicationController
  before_action :set_whatsapp_message, only: [:show, :edit, :update, :destroy]

  # GET /whatsapp_messages
  # GET /whatsapp_messages.json
  def index
    @whatsapp_messages = WhatsappMessage.all
  end

  # GET /whatsapp_messages/1
  # GET /whatsapp_messages/1.json
  def show
  end

  # GET /whatsapp_messages/new
  def new
    @whatsapp_message = WhatsappMessage.new
  end

  # GET /whatsapp_messages/1/edit
  def edit
  end

  # POST /whatsapp_messages
  # POST /whatsapp_messages.json
  def create
    @whatsapp_message = WhatsappMessage.new(whatsapp_message_params)

    respond_to do |format|
      if @whatsapp_message.save
        format.html { redirect_to @whatsapp_message, notice: 'Whatsapp message was successfully created.' }
        format.json { render :show, status: :created, location: @whatsapp_message }
      else
        format.html { render :new }
        format.json { render json: @whatsapp_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /whatsapp_messages/1
  # PATCH/PUT /whatsapp_messages/1.json
  def update
    respond_to do |format|
      if @whatsapp_message.update(whatsapp_message_params)
        format.html { redirect_to @whatsapp_message, notice: 'Whatsapp message was successfully updated.' }
        format.json { render :show, status: :ok, location: @whatsapp_message }
      else
        format.html { render :edit }
        format.json { render json: @whatsapp_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /whatsapp_messages/1
  # DELETE /whatsapp_messages/1.json
  def destroy
    @whatsapp_message.destroy
    respond_to do |format|
      format.html { redirect_to whatsapp_messages_url, notice: 'Whatsapp message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_whatsapp_message
      @whatsapp_message = WhatsappMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def whatsapp_message_params
      params.require(:whatsapp_message).permit(:wa_date, :wa_content, :wa_from, :username, :message_type, :stack_level)
    end
end
