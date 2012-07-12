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
    # puts "  5 * * * * cd /data/my_app/current && /usr/bin/rake RAILS_ENV=#{Rails.env} rmonitor:monitoring"
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

  desc "Execute monitoring for all servers"
  task :monitoring => :environment do
    puts ""

    servers       = Server.includes(:monitorings).all
    server_status = true
    alerts        = []

    servers.each do |server|
      puts " -- Server #{server.name}"

      protocols = ["Ping"]

      protocols.each do |p|
        monitoring = server.monitorings.last
        status     = (("RMonitor::Modules::Monitorings::#{p}").constantize).execute(server.host.to_s)
        server_status = false if !status

        if monitoring.nil? || monitoring.status != status
          m = Monitoring.new
          m.server   = server
          m.protocol = p
          m.status = status
          m.save

          alerts << m unless monitoring.nil?
        end

        puts " ---- #{p} = #{status}"
        puts ""
      end

      server.status = server_status
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
