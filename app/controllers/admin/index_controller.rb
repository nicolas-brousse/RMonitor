class Admin::IndexController < ApplicationController
  layout "admin"

  def index
  end

  def info
  end

  def servers
    @servers = Server.all
  end

  def settings
  end

end
