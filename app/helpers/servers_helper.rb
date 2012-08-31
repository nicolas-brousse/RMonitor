module ServersHelper
  def server_status_badge(server)
    "<span class=\"badge badge-#{server_status_class(server)}\">&nbsp;</span>".html_safe
  end

  def server_status_class(server)
    case server.status
      when 2
        'success'
      when 1
        'warning'
      else
        'important'
    end
  end

  def server_status_label(server)
    case server.status
      when 2
        t 'green'
      when 1
        t 'yellow'
      else
        t 'red'
    end
  end
end
