class IndexController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :index
  before_filter :can_show_self?,          :only => :index

  def index
    @servers =  Server.publics
                      .includes(:monitorings)
                      .includes(:incidents)
                      .order('status, name')
  end

  def dashboard
    @monitorings =  Monitoring.includes(:server)
                              .group("protocol")
                              .order("created_at DESC")
                    .delete_if {|m| m if m.status != false }
  end

private
  def can_show_self?
    redirect_to :dashboard if !Setting.monitoring_is_public? && !user_signed_in?
  end
end
