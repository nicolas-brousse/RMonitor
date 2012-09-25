require 'rmonitor/tasks/monitorings/protocol_worker'

module RMonitor
  module Tasks
    module Monitorings
      class ServerWorker
        include Sidekiq::Worker

        def perform(server_id)
          server    = Server.find(server_id)
          protocols = server.preferences.monitorings || []

          protocols.each do |p|
            RMonitor::Tasks::Monitorings::ProtocolWorker.perform_async(server.id, p)
          end
        end

      end
    end
  end
end
