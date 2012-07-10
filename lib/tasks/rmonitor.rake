require 'timeout'
require 'socket'

def ping(host)
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

namespace :rmonitor do

  desc "Execute ping for all servers"
  task :ping => :environment do
    servers = ["80.248.216.62", "dev.opsone.net", "hosting.opsone.net"]

    servers.each do |server|
      puts "Ping #{server}"
      puts ping(server.to_s) ? "OK" : "NOT OK"
    end
  end

end
