module RMonitor
  module Commands
    class StartCommand < Base

      register_command :name        => "start",
                       :description => "Start  RMonitor"

      def run
        puts "start"
        # system "rails s"
      end

    end
  end
end