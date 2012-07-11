class Admin::ServersController < Admin::BaseController

  def initialize
    super
    add_breadcrumb "Servers", :admin_servers
  end

  def index
    @servers = Server.all
  end

  def show
    @server = Server.find(params[:id])
    add_breadcrumb "#{@server.name} \##{@server.id}", admin_server_path(@server)
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
    @server = Server.find(params[:id])
    @server.destroy

    respond_to do |format|
      format.html { redirect_to admin_servers_path() }
    end
  end

end
