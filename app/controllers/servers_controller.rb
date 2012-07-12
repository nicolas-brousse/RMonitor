class ServersController < ApplicationController
  before_filter :init_breadcrumb, :except => [:create, :update, :destroy]

  # GET /servers/
  def index
    @servers = Server.all
  end

  # GET /servers/:id
  def show
    @server = Server.find(params[:id])
    env["rmonitor.current_server"] = @server

    add_breadcrumb "#{@server.name} \##{@server.id}", server_path(@server)
  end

  # GET /servers/new
  def new
    add_breadcrumb "New server", new_server_path()
    @server = Server.new
  end

  # GET /servers/:id/edit
  def edit
    @server = Server.find(params[:id])
    env["rmonitor.current_server"] = @server

    add_breadcrumb "#{@server.name} \##{@server.id}", edit_server_path(@server)
  end

  # POST /servers/
  def create
    @server = Server.new(params[:server])

    respond_to do |format|
      if @server.save
        format.html { redirect_to server_path(@server) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /servers/:id
  def update
    @server = Server.find(params[:id])

    respond_to do |format|
      if @server.update_attributes(params[:server])
        format.html { redirect_to server_path(@server) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /servers/:id
  def destroy
    @server = Server.find(params[:id])
    @server.destroy

    respond_to do |format|
      format.html { redirect_to servers_path() }
    end
  end

private
  def init_breadcrumb
    add_breadcrumb "Servers", servers_path()
  end
end
