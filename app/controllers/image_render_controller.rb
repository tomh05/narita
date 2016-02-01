class ImageRenderController < ApplicationController
  def show
    send_file File.join('/var/lib/data-diode/imgstore/',params[:name]), :disposition => 'inline'
  end
end
