class PublicController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :can_show_self?

  def index
    @servers = Server.publics
                     .includes(:monitorings)
                     .order('status, name')
    #                  .includes(:incidents)
    #                  .order('status, name')
  end

  def show
    @server = Server.publics
                    .includes(:monitorings)
                    .includes(:incidents)
                    .find(params[:id])
  end

private
  def can_show_self?
    # redirect_to :dashboard unless Setting.find_by_name('monitoring_is_public') && user_signed_in?
    redirect_to :dashboard unless user_signed_in?
  end
end
