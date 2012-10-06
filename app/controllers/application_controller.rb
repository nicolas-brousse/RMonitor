require 'rmonitor'

class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to :dashboard
  end


  before_filter :authenticate_user!,
                :set_locale

  helper_method :sort_column, :sort_direction

protected
  def set_locale
    # TODO, verif if the language exist
    # locales = Setting.options_for(:default_language)
    # I18n.locale = current_user.locale.to_sym || Setting.default_language.to_sym || I18n.locale
    Time.zone = current_user.preferences.try(:time_zone) if user_signed_in?
    # Time.zone = nil
  end

  def sort_order
    sort_column + " " + sort_direction
  end

  def sort_column
    params[:sort] = !params[:sort].blank? ? params[:sort] : "id"
  end
  
  def sort_direction
    params[:direction] = %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
