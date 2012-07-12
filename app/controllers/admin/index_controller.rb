class Admin::IndexController < Admin::BaseController

  def dashboard
    add_breadcrumb "Dashboard", admin_dashboard_path()
  end

  def info
    add_breadcrumb "Informations", admin_info_path()
  end

end
