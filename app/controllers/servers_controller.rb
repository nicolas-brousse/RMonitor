class ServersController < ApplicationController
  before_filter :init_current_server, :except => [:index, :destroy]

  # GET /servers/
  def index
    @servers = Server.includes(:monitorings).all
  end

  # GET /servers/:id
  def show
    protocols = ["ping", "http"]
    @monitorings =  Monitoring.where("server_id = ?", @server.id)
                              .where("protocol IN (?)", protocols)
                              .group("protocol")
                              .order("created_at DESC")
                    .delete_if {|m| m if m.status != false }
  end

  # GET /servers/new
  def new
    @server = Server.new
  end

  # GET /servers/:id/settings
  def edit
  end

  # POST /servers/
  def create
    server = Server.new(params[:server])

    respond_to do |format|
      if @server.save
        format.html { redirect_to server_path(server), :notice => :server_created }
      else
        flash[:error] = server.errors.full_messages
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /servers/:id
  def update
    server = Server.find(params[:id])

    respond_to do |format|
      if server.update_attributes(params[:server])
        flash[:notice] = :server_updated
        format.html { redirect_to edit_server_path(server) }
        format.js
      else
        flash[:error] = server.errors.full_messages
        format.html { render :action => "edit" }
        format.js
      end
    end
  end

  # DELETE /servers/:id
  def destroy
    server = Server.find(params[:id])
    server.destroy

    respond_to do |format|
      format.html { redirect_to servers_path() }
    end
  end

private
  def init_current_server
    @server = Server.find(params[:id])
    env["rmonitor.current_server"] = @server
  end
end
