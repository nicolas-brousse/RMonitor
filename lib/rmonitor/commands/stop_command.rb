module RMonitor
  module Commands
    class StopCommand < Base

      register_command :name        => "stop",
                       :description => "Stop  RMonitor"

      def run
        puts "stop"
      end

    end
  end
end