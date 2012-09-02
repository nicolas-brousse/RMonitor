class IncidentsController < ApplicationController
  before_filter :init_current_server

  # GET /servers/:server_id/incidents/:id
  def show
    # TODO skip :authenticate_user! if server is public and moniroting is public
    @incident = Incident.find(params[:id])
  end

  # GET /servers/:server_id/incidents/new
  def new
    @incident = Incident.new
    @incident.monitoring_id = params[:monitoring_id] unless params[:monitoring_id].blank?
  end

  # POST 
  def create
    @incident = @server.incidents.create(params[:incident])

    respond_to do |format|
      if @incident.save
        format.html { redirect_to edit_server_incident_path(@server, @incident), :notice => :incident_added }
      else
        flash.now[:error] = @incident.errors.full_messages
        format.html { render :action => "new" }
      end
    end
  end

  # GET /servers/laboratory/incidents/new
  def edit
    @incident = Incident.find(params[:id])
  end

  # PUT /incident/:id
  def update
    @incident = Incident.find(params[:id])

    respond_to do |format|
      if @incident.update_attributes(params[:incident])
        format.html { redirect_to edit_server_incident_path(@server, @incident), :notice => :incident_updated }
      else
        flash.now[:error] = @incident.errors.full_messages
        format.html { render :action => "edit" }
      end
    end
  end

private
  def init_current_server
    @server = Server.find(params[:server_id])
    env["rmonitor.current_server"] = @server
  end
end
