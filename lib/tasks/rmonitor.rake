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
    servers = Server.all

    servers.each do |server|
      puts " -- Ping #{server.name}"
      server.status = ping(server.host.to_s)
      server.synchronized_at = Time.now
      server.save
    end
  end

end
