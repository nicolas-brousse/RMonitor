module RMonitor
  module Tasks
    module Monitorings
      class Server
        include Sidekiq::Worker

        def perform(server_id)
          server    = Server.find(server_id)
          protocols = server.preferences.monitorings || []

          protocols.each do |p|
            RMonitor::Tasks::Monitorings::Protocol.perform_async(server.id, p)
          end
        end

      end
    end
  end
end
