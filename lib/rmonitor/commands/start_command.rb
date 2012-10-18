require 'daemon_controller'

module RMonitor
  module Commands
    class StartCommand < Base

      register_command :name        => "start",
                       :description => "Start  RMonitor"

      # register_argument :daemon, :aliases => "-d", :desc => "Daemonize"

      def run
        shell.say "Start RMonitor", :green
        shell.say "--------------------------------"
        # system "bundle exec rails s"

        # Start Redis server
        skip_redis_server = false
        unless skip_redis_server
          shell.say ">>  Run Redis server", :yellow
          system "bundle exec redis start"
        end

        # Start Sidekiq
        shell.say ">>  Run Sidekiq", :yellow
        sidekiq_daemon.start

        # Start Rails server (if not skiped)
        skip_rails_server = false
        unless skip_rails_server
          shell.say ">>  Run Rails server", :yellow
          rails_daemon.start
        end
      end

    private
      def sidekiq_daemon
        @sidekiq_daemon ||= DaemonController.new(
          :identifier => 'Sidekiq server',
          :start_command => "bundle exec sidekiq -",
          :ping_command => lambda { TCPSocket.new('localhost', @port) },
          :pid_file => "#{Rails.root}/tmp/pids/sidekiq.pid",
          :log_file => "#{Rails.root}/log/sidekiq.log",
        )
      end

      def rails_daemon(port=3000)
        @rails_daemon ||= DaemonController.new(
          :identifier => 'Rails server',
          :start_command => "bundle exec rails s -p #{port}",
          :ping_command => lambda { TCPSocket.new('localhost', port) },
          :pid_file => "#{Rails.root}/tmp/pids/sidekiq.pid",
          :log_file => "#{Rails.root}/log/sidekiq.log",
        )
      end

    end
  end
end