class AppNamesController < ApplicationController
  before_action :set_app_name, only: [:show, :edit, :update, :destroy]

  # GET /app_names
  # GET /app_names.json
  def index
    @app_names = AppName.all
  end

  # GET /app_names/1
  # GET /app_names/1.json
  def show
  end

  # GET /app_names/new
  def new
    @app_name = AppName.new
  end

  # GET /app_names/1/edit
  def edit
  end

  # POST /app_names
  # POST /app_names.json
  def create
    @app_name = AppName.new(app_name_params)

    respond_to do |format|
      if @app_name.save
        format.html { redirect_to @app_name, notice: 'App name was successfully created.' }
        format.json { render :show, status: :created, location: @app_name }
      else
        format.html { render :new }
        format.json { render json: @app_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_names/1
  # PATCH/PUT /app_names/1.json
  def update
    respond_to do |format|
      if @app_name.update(app_name_params)
        format.html { redirect_to @app_name, notice: 'App name was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_name }
      else
        format.html { render :edit }
        format.json { render json: @app_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_names/1
  # DELETE /app_names/1.json
  def destroy
    @app_name.destroy
    respond_to do |format|
      format.html { redirect_to app_names_url, notice: 'App name was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_name
      @app_name = AppName.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_name_params
      params.require(:app_name).permit(:longname, :shortname, :color, :priority)
    end
end
