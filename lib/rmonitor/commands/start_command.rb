module RMonitor
  module Commands
    class StartCommand < Base

      register_command :name        => "start",
                       :description => "Start  RMonitor"

      # register_argument :daemon, :aliases => "-d", :desc => "Daemonize"

      def run
        shell.say "Start RMonitor", :green
        shell.say "--------------------------------"
        # exec "bundle exec rails s"

        # Start Redis server
        skip_redis_server = false
        unless skip_redis_server
          shell.say "  Run Redis server"
          exec "bundle exec redis start"
        end

        # Start Sidekiq
        shell.say "  Run Sidekiq"
        exec "bundle exec sidekiq"

        # Start Rails server (if not skiped)
        skip_rails_server = false
        unless skip_rails_server
          shell.say "  Run Rails server"
          exec "bundle exec rails s"
        end
      end

    end
  end
end