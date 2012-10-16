require 'rmonitor'

class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to :dashboard
  end

  before_filter :authenticate_user!,
                :set_locale_and_time_zone

  helper_method :sort_column, :sort_direction

protected
  def set_locale_and_time_zone
    if current_user && Setting.options_for(:default_language).include?(current_user.language)
      I18n.locale = current_user.language.to_sym
    else
      I18n.locale = Setting.default_language.to_sym || I18n.locale
    end

    Time.zone = current_user.preferences.try(:time_zone) if user_signed_in?
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
