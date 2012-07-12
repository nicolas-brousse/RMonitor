class MonitoringMailer < ActionMailer::Base
  default from: "no-reply@rmonitor.com"

  def alert_email(user, monitorings)
    @user        = user
    @monitorings = monitorings
    @url         = "http://example.com/login"

    mail(:to => user.email, :subject => "Monitoring alert")
  end
end
