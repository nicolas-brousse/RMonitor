class IncidentsController < ApplicationController
  before_filter :init_current_server

  # GET /incident/:id
  def show
    @incident = Incident.find(params[:id])
  end

  # GET /incident/:id/edit
  def edit
    @incident = Incident.find(params[:id])
  end

  # PUT /incident/:id
  def update
    @incident = Incident.find(params[:id])

    respond_to do |format|
      if @incident.update_attributes(params[:incident])
        format.html { redirect_to edit_server_incident_path(@incident), :notice => :incident_updated }
      else
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
