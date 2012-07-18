class MonitoringsController < ApplicationController
  before_filter :init_current_server

  def index
    @monitorings = Monitoring.where("server_id = ?", @server.id)
                             .where("protocol IN (?)", ["ping", "http"])
                             .group("protocol")
                             .order("created_at DESC")
  end

  def show
    @protocol = params[:protocol_type]
    redirect_to servers_monitorings_path(:server_id => @server.id), :alert => t(:wrong_protocol_asked) unless RMonitor::Modules::Monitorings.protocol_exists? @protocol

    @monitorings = Monitoring.where("server_id = ?", @server.id)
                             .where("protocol = ?", @protocol)
  end


private
  def init_current_server
    @server = Server.find(params[:server_id])
    env["rmonitor.current_server"] = @server
  end
end

