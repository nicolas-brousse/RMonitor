require 'rmonitor'

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!,
                :set_locale

protected
  def set_locale
    # TODO, verif if the language exist
    # I18n.locale = current_user.locale.to_sym || Setting.default_language.to_sym || I18n.locale
    Time.zone = current_user.preferences.time_zone if user_signed_in?
    # Time.zone = nil
  end
end
