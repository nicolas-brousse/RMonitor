module RMonitor
  module Commands
    class VersionCommand < Base

      register_command :name        => "version",
                       :description => "version of rmonitor"

      def run
        puts ""
        puts "Version:"
        puts "  " + RMonitor::Info.versioned_name
        puts ""
        puts RMonitor::Info.environment
        puts ""
      end

    end
  end
end