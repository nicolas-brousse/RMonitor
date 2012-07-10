class DefaultController < ApplicationController

  def index
    render :layout => "public"
  end

  def projects_list
  end

  def project_show
  	render :layout => "serveur"
  end
end
