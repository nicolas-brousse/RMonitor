class DefaultController < ApplicationController

  def projects_list
  end

  def project_show
    render :layout => "serveur"
  end
end
