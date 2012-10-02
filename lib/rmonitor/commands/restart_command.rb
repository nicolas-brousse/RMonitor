module RMonitor
  module Commands
    class RestartCommand < Base

      register_command :name        => "restart",
                       :description => "Retart  RMonitor"

      def run
        StopCommand.run
        StartCommand.run
      end

    end
  end
end