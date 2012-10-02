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
    @monitorings = []
    Server.publics.each do |s|
      s.preferences.monitorings.each do |p|
        m = Monitoring.where("server_id = ?", s.id)
                      .where("protocol = ?", p)
                      .order("created_at DESC")
                      .first
        @monitorings << m if !m.nil? && m.status == false
      end
    end
  end

private
  def can_show_self?
    redirect_to :dashboard if !Setting.monitoring_is_public? && !user_signed_in?
  end
end
