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


    respond_to do |format|
      format.html { redirect_to :admin_settings, :notice => :settings_updated }
      format.js   { flash.now[:notice] = :settings_updated }
    end
  end

end
