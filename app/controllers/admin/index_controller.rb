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
    @settings = Setting
  end

  def settings_save
    params[:settings].each do |k, v|
      Setting[k] = v
    end

    redirect_to :admin_settings
  end

end
