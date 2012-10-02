require "timeout"
require "socket"

require "rmonitor/modules/monitorings/abstract_protocol"

module RMonitor
  module Modules
    module Monitorings
      class DNS < AbstractProtocol #:nodoc:

        def self.execute(host)
          begin
            Timeout.timeout(15) do 
              s = TCPSocket.new(host, 53)
              s.close
              return true
            end
          rescue Errno::ECONNREFUSED
            return false
          rescue Timeout::Error
            return false
          rescue Exception
            return false
          end
        end

      end
    end
  end
end