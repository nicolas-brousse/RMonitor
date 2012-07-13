class PublicController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    @servers = Server.publics
                     .includes(:monitorings)
                     .order('status, name')
    # @servers = Server.publics
    #                  .includes(:monitorings)
    #                  .includes(:incidents)
    #                  .order('status, name')
  end

  def show
    @server = Server.publics
                    .includes(:monitorings)
                    .includes(:incidents)
                    .find(params[:id])
  end

end
