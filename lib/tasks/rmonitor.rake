require 'rmonitor'
require 'rmonitor/modules/monitoring/ping'


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
    servers = Server.all

    servers.each do |server|
      puts " -- Ping #{server.name}"
      server.status = RMonitor::Modules::Monitoring::Ping.execute(server.host.to_s)
      server.synchronized_at = Time.now
      server.save
    end

    # Prevent users
    User.all.each do |user|
      # MonitoringMailer.alert_email(user).deliver
    end
  end

end
