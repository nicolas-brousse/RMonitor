require 'rmonitor/modules/monitorings/ping'
require 'rmonitor/modules/monitorings/http'
require 'rmonitor/modules/monitorings/dns'
require 'rmonitor/modules/monitorings/ssh'
require 'rmonitor/modules/monitorings/ftp'
require 'rmonitor/tasks/monitorings/server_worker'

module RMonitor
  module Tasks
    class MonitoringsWorker
      include Sidekiq::Worker

      def desc
        "Execute monitoring for all servers"
      end

      def perform
        puts ""

        servers       = Server.includes(:monitorings).all
        servers.each do |server|
          RMonitor::Tasks::Monitorings::ServerWorker.perform_async(server.id)
        end
      end

      def self.execute
        puts ""

        servers       = Server.includes(:monitorings).all
        alerts        = []

        servers.each do |server|
          puts " -- Server #{server.name}"

          server_status = 0
          protocols = server.preferences.monitorings || []

          protocols.each do |p|
            monitoring = server.monitorings.where('protocol = ?', p).last
            status     = (("RMonitor::Modules::Monitorings::#{p.camelize}").constantize).execute(server.host.to_s)
            server_status += 1 if status == Monitoring::DOWN

            if monitoring.nil? || monitoring.status != status
              m = Monitoring.new
              m.server   = server
              m.protocol = p
              m.status = status
              m.save!

              alerts << m if !monitoring.nil? && monitoring.status != Monitoring::UP
            end

            puts " ---- #{p} = #{status}"
          end


          if server_status == 0
            server.status = 2 #=> green
          elsif server_status > 0 && server_status < protocols.count
            server.status = 1 #=> yellow
          else
            server.status = 0 #=> red
          end

          server.synchronized_at = Time.current
          server.save!

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


      def check_server(server)
        # TODO
        #   If server check return false
        #   recursive call all 30 seconds
      end

    end
  end
end
