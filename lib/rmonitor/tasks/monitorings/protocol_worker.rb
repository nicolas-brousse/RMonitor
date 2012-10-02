require 'rmonitor/modules/monitorings/ping'
require 'rmonitor/modules/monitorings/http'

module RMonitor
  module Tasks
    module Monitorings
      class ProtocolWorker
        include Sidekiq::Worker

        def perform(server_id, protocol)
          # TODO: Create a locker
          # return nil if lock

          server = Server.includes(:monitorings).find(server_id)
          protocols = server.preferences.monitorings || []

          monitoring = server.monitorings.where('protocol = ?', protocol.to_s).last
          status     = (("RMonitor::Modules::Monitorings::#{protocol.to_s.camelize}").constantize).execute(server.host.to_s)

          if monitoring.nil? || monitoring.status != status
            m = Monitoring.new
            m.server   = server
            m.protocol = protocol.to_s
            m.status = status
            m.save

            alerts << m if !monitoring.nil? && monitoring.status != Monitoring::UP # Send an email OR prepare an email (Use a thread — if use thread, send the name in perform)
          end
          puts " ---- #{protocol.to_s} = #{status}"
          # TODO, write into rmonitor_{env}.log

          #
          # Update Server status
          #
          server_status = 0

          server.monitorings.each do |m|
            server_status += 1 if m.status == Monitoring::DOWN
          end

          server.status = 0 #=> red
          server.status = 1 if server_status > 0 && server_status < protocols.count #=> yellow
          server.status = 2 if server_status == 0 #=> green

          server.save

        end
      end
    end
  end
end
