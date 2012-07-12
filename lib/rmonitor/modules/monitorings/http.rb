require "net/http"
require "uri"
require "timeout"

module RMonitor
  module Modules
    module Monitorings
      class HTTP #:nodoc:

        def self.execute(host)
          begin
            Timeout.timeout(15) do 
              uri = URI.parse("http://#{host}")
              http = Net::HTTP.new(uri.host, uri.port)
              request = Net::HTTP::Get.new(uri.request_uri)
              response = http.request(request)

              if response.code != 200
                return false
              else
                return true
              end
            end
          rescue Errno::ECONNREFUSED
            return false
          rescue Timeout::Error
            return false
          end
        end

      end
    end
  end
end