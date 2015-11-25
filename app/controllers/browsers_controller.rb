class BrowsersController < ApplicationController
  before_action :set_browser, only: [:show, :edit, :update, :destroy]

  # GET /browsers
  # GET /browsers.json
  def index
    @browsers = Browser.all
  end

  # GET /browsers/1
  # GET /browsers/1.json
  def show
  end

  # GET /browsers/new
  def new
    @browser = Browser.new
  end

  # GET /browsers/1/edit
  def edit
  end

  # POST /browsers
  # POST /browsers.json
  def create
    @browser = Browser.new(browser_params)

    respond_to do |format|
      if @browser.save
        format.html { redirect_to @browser, notice: 'Browser was successfully created.' }
        format.json { render :show, status: :created, location: @browser }
      else
        format.html { render :new }
        format.json { render json: @browser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /browsers/1
  # PATCH/PUT /browsers/1.json
  def update
    respond_to do |format|
      if @browser.update(browser_params)
        format.html { redirect_to @browser, notice: 'Browser was successfully updated.' }
        format.json { render :show, status: :ok, location: @browser }
      else
        format.html { render :edit }
        format.json { render json: @browser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /browsers/1
  # DELETE /browsers/1.json
  def destroy
    @browser.destroy
    respond_to do |format|
      format.html { redirect_to browsers_url, notice: 'Browser was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    f = open("https://s3-us-west-2.amazonaws.com/bbcirfs/coot/logs/"+params[:filepath]+".csv");
    csv_text = f.read
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      parsed_visit_date = DateTime.parse(row[4].to_s)
      @browser = Browser.find_or_initialize_by(title: row[2].to_s, url: row[3].to_s, visit_total: row[5].to_i, username: row[6].to_s)
      @browser.visit_date = parsed_visit_date
      @browser.save
    end

    @data = {'result' => 'Browser imported'}
    respond_to do |format|
        format.json {render :json => @data.as_json}
    end   
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_browser
      @browser = Browser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def browser_params
      params.require(:browser).permit(:username, :title, :url)
    end
end
