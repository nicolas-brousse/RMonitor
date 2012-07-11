class Admin::ServersController < Admin::BaseController
  before_filter :init_breadcrum, :except => [:create, :update, :destroy]

  # GET /admin/servers/
  def index
    @servers = Server.all
  end

  # GET /admin/servers/:id
  def show
    @server = Server.find(params[:id])
    add_breadcrumb "#{@server.name} \##{@server.id}", admin_server_path(@server)
  end

  # GET /admin/servers/new
  def new
    add_breadcrumb "New server", new_admin_server_path()
    @server = Server.new
  end

  # GET /admin/servers/:id/edit
  def edit
    @server = Server.find(params[:id])
    add_breadcrumb "#{@server.name} \##{@server.id}", edit_admin_server_path(@server)
  end

  # POST /admin/servers/
  def create
    @server = Server.new(params[:server])

    respond_to do |format|
      if @server.save
        format.html { redirect_to admin_server_path(@server) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /admin/servers/:id
  def update
    @server = Server.find(params[:id])

    respond_to do |format|
      if @server.update_attributes(params[:server])
        format.html { redirect_to admin_server_path(@server) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELTE /admin/servers/:id
  def destroy
    @server = Server.find(params[:id])
    @server.destroy

    respond_to do |format|
      format.html { redirect_to admin_servers_path() }
    end
  end

private
    def init_breadcrum
      add_breadcrumb "Servers", admin_servers_path()
    end
end
