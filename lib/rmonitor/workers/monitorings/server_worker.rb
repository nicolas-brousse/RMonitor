require 'rmonitor/workers/monitorings/protocol_worker'

module RMonitor
  module Workers
    module Monitorings
      class ServerWorker
        include Sidekiq::Worker

        def perform(server_id)
          server    = Server.find(server_id)
          protocols = server.preferences.monitorings || []

          protocols.each do |p|
            RMonitor::Workers::Monitorings::ProtocolWorker.perform_async(server.id, p)
          end
        end

      end
    end
  end
end
