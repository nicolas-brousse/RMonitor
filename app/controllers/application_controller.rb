require 'rmonitor'

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

protected
  def set_locale
    I18n.locale = :en
    Time.zone = current_user.time_zone
  end

  def add_breadcrumb name, url = ''
    @breadcrumbs ||= []
    url = eval(url) if url =~ /_path|_url|@/
    @breadcrumbs << [name, url]
  end

  def self.add_breadcrumb name, url, options = {}
    before_filter options do |controller|
      controller.send(:add_breadcrumb, name, url)
    end
  end
end
