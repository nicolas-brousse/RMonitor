require 'timeout'
require 'socket'

module RMonitor
  module Modules
    module Monitorings
      class Ping #:nodoc:

        def self.execute(host)
          begin
            Timeout.timeout(15) do 
              s = TCPSocket.new(host, 'echo')
              s.close
              return true
            end
          rescue Errno::ECONNREFUSED
            return true
          rescue Timeout::Error
            return false
          end
        end

      end
    end
  end
end