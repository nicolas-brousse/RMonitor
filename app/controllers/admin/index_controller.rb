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
      flash[:notice] = :settings_updated

      format.html { redirect_to :admin_settings }
      format.js
    end
  end

end
