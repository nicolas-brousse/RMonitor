require "net/http"
require "uri"
require "timeout"

require "rmonitor/modules/monitorings/abstract_protocol"

module RMonitor
  module Modules
    module Monitorings
      class HTTP < AbstractProtocol #:nodoc:

        def self.execute(host)
          begin
            Timeout.timeout(15) do 
              uri  = URI.parse("http://#{host}")
              http = Net::HTTP.new(uri.host, uri.port)
              req  = Net::HTTP::Get.new(uri.request_uri)
              res  = http.request(req)

              return res.code.to_i == 200
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
