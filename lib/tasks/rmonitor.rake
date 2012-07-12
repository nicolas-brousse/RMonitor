require 'rmonitor'
require 'rmonitor/modules/monitorings/ping'


namespace :rmonitor do

  desc "Install RMonitor"
  task :install => :environment do
    # TODO - Execute rake cmd
    #
    #    * rake db:setup
    #    * rake db:migrate
    #

    puts "Install RMonitor Database for #{Rails.env} env"
    # Rake::Task['db:setup'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke

    # puts "Now configure your cronjob"
    # puts "  5 * * * * cd /data/my_app/current && /usr/bin/rake RAILS_ENV=#{Rails.env} rmonitor:ping"
  end

  desc "Update RMonitor"
  task :update => :environment do
    # TODO - Execute rake cmd
    #
    #    * rake db:setup
    #    * rake db:migrate
    #

    puts "Update RMonitor Database for #{Rails.env} env"
    Rake::Task['db:migrate'].invoke
    # Rake::Task['db:seed'].invoke

    # puts "Now configure your cronjob"
    # puts "  5 * * * * cd /data/my_app/current && /usr/bin/rake RAILS_ENV=#{Rails.env} rmonitor:ping"
  end

  desc "Version of RMonitor"
  task :version => :environment do
    puts ""
    puts "Version:"
    puts "  " + RMonitor::Info.versioned_name
    puts ""
    puts RMonitor::Info.environment
    puts ""
  end

  desc "Execute ping for all servers"
  task :ping => :environment do
    servers = Server.includes(:monitorings).all
    alerts  = []

    servers.each do |server|
      puts " -- Ping #{server.name}"

      monitoring = server.monitorings.last
      status     = RMonitor::Modules::Monitorings::Ping.execute(server.host.to_s)

      if monitoring.nil? || monitoring.status != status
        first_alert = monitoring.nil? ? true : false

        monitoring = Monitoring.new
        monitoring.server   = server
        monitoring.protocol = "Ping"
        monitoring.status = status
        monitoring.save

        alerts << monitoring unless first_alert
      end

      server.status = status
      server.synchronized_at = Time.now
      server.save
    end

    # Prevent users
    unless alerts.empty?
      User.all.each do |user|
        monitorings = []
        alerts.each do |a|
          # verif if user must be prevent and can be prevent
          monitorings << a
        end

        MonitoringMailer.alert_email(user, monitorings).deliver
      end
    end

  end

end
