require 'rmonitor/modules/monitorings/ping'
require 'rmonitor/modules/monitorings/http'

module RMonitor
  module Tasks
    module Monitorings
      class Protocol
        include Sidekiq::Worker

        def perform(server_id, protocol)
          server = Server.find(server_id)
                         .includes(:monitorings)

          monitoring = server.monitorings.where('protocol = ?', protocol.to_s).last
          status     = (("RMonitor::Modules::Monitorings::#{protocol.to_s.camelize}").constantize).execute(server.host.to_s)
          server_status += 1 if status == Monitoring::DOWN
          if monitoring.nil? || monitoring.status != status
            m = Monitoring.new
            m.server   = server
            m.protocol = protocol.to_s
            m.status = status
            m.save
            alerts << m if !monitoring.nil? && monitoring.status != Monitoring::UP
          end
          puts " ---- #{protocol.to_s} = #{status}"
          # TODO, write into rmonitor_{env}.log
        end

      end
    end
  end
end
