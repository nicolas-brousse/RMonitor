class DefaultController < ApplicationController

  def index
    @servers = Server.publics
    render :layout => "public"
  end

  def projects_list
  end

  def project_show
  	render :layout => "serveur"
  end
end
