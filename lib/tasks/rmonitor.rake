require 'rmonitor'

namespace :rmonitor do

  namespace :app do

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

      puts "Now configure your cronjob"
      puts "  5 * * * * cd #{Rails.root} && /full/path/to/rvm/bin/rake RAILS_ENV=#{Rails.env} -f Rakefile rmonitor:monitoring"
    end

    desc "Update RMonitor"
    task :update => :environment do
      # TODO - Execute rake cmd
      #
      #    * rake db:setup
      #    * rake db:migrate
      #

      puts "Update RMonitor Application"
      `cd #{Rails.root} && git pull origin`

      puts "Update RMonitor Database for #{Rails.env} env"
      Rake::Task['db:migrate'].invoke
      # Rake::Task['db:seed'].invoke

      puts ""
      puts "Now configure your cronjob"
      puts "  5 * * * * cd #{Rails.root} && /full/path/to/rvm/bin/rake RAILS_ENV=#{Rails.env} -f Rakefile rmonitor:monitoring"
    end

    desc "Version of RMonitor Application"
    task :version => :environment do
      puts ""
      puts "Version:"
      puts "  " + RMonitor::Info.versioned_name
      puts ""
      puts RMonitor::Info.environment
      puts ""
    end

  end

  desc "Execute monitoring for all servers"
  task :monitoring => :environment do
    require 'rmonitor/modules/monitorings'
    require 'rmonitor/modules/monitorings/ping'
    require 'rmonitor/modules/monitorings/http'

    puts ""

    servers       = Server.includes(:monitorings).all
    server_status = true
    alerts        = []

    servers.each do |server|
      puts " -- Server #{server.name}"

      protocols = server.preferences.monitorings || []

      protocols.each do |p|
        monitoring = server.monitorings.where('protocol = ?', p).last
        status     = (("RMonitor::Modules::Monitorings::#{p.camelize}").constantize).execute(server.host.to_s)
        server_status = 0

        if monitoring.nil? || monitoring.status != status
          m = Monitoring.new
          m.server   = server
          m.protocol = p
          m.status = status
          m.save

          server_status += 1 if status == false
          alerts << m if !monitoring.nil? && monitoring.status != true
        end

        puts " ---- #{p} = #{status}"
      end

      # server_status == 0 => green
      # server_status > 0 && server_status < protocols.count => yellow
      # server_status > protocols.count => red
      server.status = server_status <= 0 ? true : false
      server.synchronized_at = Time.current
      server.save

      puts " ------ Current uptime = #{server.uptime.round(2)}%"
      puts ""
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
