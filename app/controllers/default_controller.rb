class DefaultController < ApplicationController

  def index
  end

  def projects_list
  end

  def project_show
  	render :layout => "serveur"
  end
end
