class ServersController < ApplicationController
  before_filter :init_current_server, :except => [:index, :new, :create, :destroy]

  # GET /servers/
  def index
    @servers = Server.includes(:monitorings).all
  end

  # GET /servers/:id
  def show
    @monitorings =  Monitoring.where("server_id = ?", @server.id)
                              .where("protocol IN (?)",  @server.preferences.monitorings)
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
    @server = Server.new(params[:server])

    respond_to do |format|
      if @server.save
        format.html { redirect_to edit_server_path(@server), :notice => :server_created }
      else
        flash.now[:error] = @server.errors.full_messages
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /servers/:id
  def update
    @server = Server.find(params[:id])
    params[:server][:preferences] = OpenStruct.new(params[:server][:preferences])

    respond_to do |format|
      if @server.update_attributes(params[:server])
        format.html { redirect_to edit_server_path(@server), :notice => :server_updated }
        format.js   { flash.now[:notice] = :server_updated }
      else
        flash.now[:error] = @server.errors.full_messages
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
      format.html { redirect_to :back }
    end
  end

private
  def init_current_server
    @server = Server.find(params[:id])
    env["rmonitor.current_server"] = @server
  end
end
