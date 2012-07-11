class PublicController < ApplicationController

  def index
    @servers = Server.publics.order('status, name')
    # render :layout => "public"
  end

  def show
    @server = Server.publics.find(params[:id])
  end

end
