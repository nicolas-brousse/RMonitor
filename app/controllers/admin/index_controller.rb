class Admin::IndexController < ApplicationController
  before_filter :init_breadcrumb

  def index
  end

  def info
    add_breadcrumb "Informations", admin_info_path()
  end

  def servers
    add_breadcrumb "Servers", admin_servers_path()
    @servers = Server.all
  end

private
  def init_breadcrumb
    add_breadcrumb "Administration", admin_path()
  end
end
