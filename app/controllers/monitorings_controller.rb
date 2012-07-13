class MonitoringsController < ApplicationController
  before_filter :init_current_server

  def index
    @monitorings = Monitoring.where("server_id = ?", @server.id)
                             .where("protocol IN (?)", ["Ping", "HTTP"])
                             .group("protocol")
  end

  def show
    # TODO - verif, protocol is valid and activated on this server
    @monitoring = Monitoring.where("server_id = ?", @server.id)
                            .where("protocol = ?", params[:protocol])
  end


private
  def init_current_server
    @server = Server.find(params[:id])
    env["rmonitor.current_server"] = @server
  end
end

