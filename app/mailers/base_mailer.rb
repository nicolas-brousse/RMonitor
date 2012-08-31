# http://stackoverflow.com/questions/4313177/sending-mail-with-rails-3-in-development-environment
class BaseMailer < ActionMailer::Base
  default from: Setting.mail_from
end
