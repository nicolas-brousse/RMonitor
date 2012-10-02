class MonitoringsController < ApplicationController
  before_filter :init_current_server

  # GET /servers/:server_id/monitorings
  def index
    @monitorings = []
    @server.preferences.monitorings.each do |p|
      m = Monitoring.where("server_id = ?", @server.id)
                    .where("protocol = ?", p)
                    .order("created_at DESC")
                    .first
      @monitorings << m unless m.nil?
    end

    @incidents = Incident.includes(:monitoring)
                         .includes(:server)
                         .where("server_id = ?", @server.id)
  end

  # GET /servers/:server_id/monitorings/:protocol_type
  def show
    @protocol = params[:protocol_type]
    redirect_to servers_monitorings_path(:server_id => @server.id), :alert => :wrong_protocol_asked unless RMonitor::Modules::Monitorings.protocol_exists? @protocol

    @monitorings = Monitoring.where("server_id = ?", @server.id)
                             .where("protocol = ?", @protocol)
  end

private
  def init_current_server
    @server = Server.find(params[:server_id])
    env["rmonitor.current_server"] = @server
  end
end

