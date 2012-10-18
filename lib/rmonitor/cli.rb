trap 'INT' do
  # Handle Ctrl-C in JRuby like MRI
  # http://jira.codehaus.org/browse/JRUBY-4637
  RMonitor::CLI.instance.interrupt
end

trap 'TERM' do
  # Heroku sends TERM and then waits 10 seconds for process to exit.
  RMonitor::CLI.instance.interrupt
end

trap 'USR1' do
  RMonitor.logger.info "Received USR1, no longer accepting new work"
end

trap 'TTIN' do
  Thread.list.each do |thread|
  end
end

$stdout.sync = true

require 'yaml'
require 'singleton'
require 'thor'
require 'thor/base'
require 'thor/util'

module RMonitor

  class CLI
    include Singleton

    def initialize
      @code = nil
      @interrupt_mutex = Mutex.new
      @interrupted = false
    end

    def start
      validate!
      write_pid
      boot_system
      CLICommands.boot_commands

      @code = nil
      RMonitor.logger

      CLICommands.start

      RMonitor.logger.level = Logger::DEBUG if options[:verbose]
    end

    def interrupt
      @interrupt_mutex.synchronize do
        unless @interrupted
          @interrupted = true
          Thread.main.raise Interrupt
        end
      end
    end

    private

    def die(code)
      exit(code)
    end

    def logger
      RMonitor.logger
    end

    def options
      path = File.realpath("#{File.dirname(__FILE__)}/../../")
      {
        :require => path,
        :pidfile => "#{path}/tmp/pids/rmonitor.pid"
      }
    end

    def detected_environment
      options[:environment] ||= ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
    end

    def boot_system
      ENV['RACK_ENV'] = ENV['RAILS_ENV'] = detected_environment
      raise ArgumentError, "#{options[:require]} does not exist" unless File.exist?(options[:require])

      if File.directory?(options[:require])
        require 'rails'
        require File.expand_path("#{options[:require]}/config/environment.rb")
        ::Rails.application.eager_load!
        require 'rmonitor'
      else
        require options[:require]
      end
    end

    def validate!
    end

    def write_pid
      if path = options[:pidfile]
        File.open(path, 'w') do |f|
          f.puts Process.pid
        end
      end
    end
  end

  class CLICommands < ::Thor
    extend Thor::Shell
    extend Thor::Base

    @@commands = Array.new

    def self.boot_commands
      self.write_commands
    end

    def self.write_banner
      say "RMonitor ", :green, nil
      say "version ", nil, nil
      say RMonitor::VERSION.to_s + "\n", :blue
    end

    def self.write_commands
      require 'rmonitor/commands'

      Dir["#{File.dirname(__FILE__)}/commands/*.{rb}"].each do |source|
        filename     = File.basename(source).split("_").first
        require "rmonitor/commands/#{filename}_command"
        command_name = "RMonitor::Commands::#{filename.camelize}Command"
        command      = (command_name.constantize).new unless defined?(command_name.constantize.to_s).nil?
        @@commands   << command

        if command && filename != 'application'
          options = ""
          # command.arguments.each do |a|
          #   options += "method_option #{a.inspect}\n"
          # end

          src = <<-END_SRC
          desc "#{command.name}", "#{command.description}"
          #{options}
          def #{command.name}
            #{command.class.name.to_s}.run
          end
          END_SRC
          class_eval src, __FILE__, __LINE__
        end
      end
    end

    def help
      list
    end

    default_task :list

    # Prints help information for this class.
    desc :list, "List commands"
    def list
      list = [["list", "# List commands"]]
      @@commands.each do |command|
        list << [command.name, "# #{command.description}"]
      end
      list.sort!{ |a,b| a[0] <=> b[0] }
      list.map!{ |c| [ shell.set_color(c[0], :green) , c[1]] }

      RMonitor::CLICommands.write_banner

      say "Usages:", :yellow
      shell.print_wrapped("rmonitor command [arguments] [options]", :indent => 2)
      say

      say "Commands:", :yellow
      print_table(list, :indent => 2, :truncate => true)
      say
    end

  end

end