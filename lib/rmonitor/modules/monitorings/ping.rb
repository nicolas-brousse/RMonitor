require 'timeout'
require 'socket'

require "abstract_protocol"

module RMonitor
  module Modules
    module Monitorings
      class Ping < AbstractProtocol #:nodoc:

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
          rescue Exception
            return false
          end
        end

      end
    end
  end
end