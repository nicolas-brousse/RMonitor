require 'timeout'
require 'socket'

module RMonitor
  class Ping #:nodoc:

    def self.execute(host)
      begin
        Timeout.timeout(5) do 
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