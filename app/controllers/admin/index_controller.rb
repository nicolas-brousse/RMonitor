class Admin::IndexController < ApplicationController
  before_filter :authorize!
  before_filter :pre_filter, :only => [:users, :servers]
  layout "admin"

  def index
  end

  def info
  end

  def users
    @users = User.order(sort_order).page(params[:page])

    if !@filter.blank? && @filter.kind_of?(Hash)
      @users = @users.search(@filter[:search]) unless @filter[:search].blank?
    end
  end

  def servers
    @servers = Server.order(sort_order).page(params[:page])

    if !@filter.blank? && @filter.kind_of?(Hash)
      @servers = @servers.search(@filter[:search]) unless @filter[:search].blank?
    end
  end

  def settings
    @settings = Setting
  end

  def settings_save
    params[:settings].each do |k, v|
      Setting[k] = v
    end

    respond_to do |format|
      format.html { redirect_to :admin_settings, :notice => :settings_updated }
      format.js   { flash.now[:notice] = :settings_updated }
    end
  end

private
  def pre_filter
    params[:filter]    = {}  unless params[:reset].nil?
    params[:sort]      = nil unless params[:reset].nil?
    params[:direction] = nil unless params[:reset].nil?
    @filter = params[:filter]
  end

  def authorize!
    raise CanCan::AccessDenied unless can? :administrate, :all
  end
end
