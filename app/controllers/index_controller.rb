class IndexController < ApplicationController

  def dashboard
    add_breadcrumb "Dashboard", dashboard_path()
  end

end
