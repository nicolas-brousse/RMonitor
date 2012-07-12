module ApplicationHelper
  def format_flash_class(type)
    {
      :success => "alert-success",
      :error   => "alert-error",
      :info    => "alert-info",
      :alert   => "",
      :notice  => "alert-info",
    }[type]
  end

  def current_server
    return request.env["rmonitor.current_server"] unless request.env["rmonitor.current_server"].nil?
    false
  end
end
