module RMonitor
  module Commands
    class SetupCommand < Base

      register_command :name        => "setup",
                       :description => "setup rmonitor"

      # register_option 
      # register_option 

      def run
        shell.say "Welcome into RMonitor Application", :green
        # shell.ask "Are you sur to install this app?", :limited_to => ["yes", "no"]
        unless shell.yes? "Are you sur to install this app?", [:black, :on_cyan, :bold]
          return exit 'Bye bye'
        end

        shell.say Thor::Shell::Color::ON_RED
        shell.say Thor::Shell::Color::GREEN, nil
        txt_with_color = 'message'#shell.set_color('message', :green, :on_white)
        shell.print_wrapped(txt_with_color, :indent => 5)
        shell.say Thor::Shell::Color::CLEAR

        shell.error("fatal")

        # require 'fileutils'

        # # copy config files
        # Dir['config/examples/*'].each do |source|
        #   destination = "config/#{File.basename(source)}"
        #   unless File.exist? destination
        #     FileUtils.cp(source, destination)
        #     puts "Generated #{destination}"
        #   end
        # end

        # # TODO - Execute rake cmd
        # #
        # #    * rake db:setup
        # #    * rake db:migrate
        # #

        # input = ''
        # STDOUT.puts "Are you sure to install rmonitor?"
        # input = STDIN.gets.chomp
        # raise "bah, humbug!" unless input.capitalize == "Y"

        # puts "Install RMonitor Database for #{Rails.env} env"
        # # Rake::Task['db:setup'].invoke
        # Rake::Task['db:migrate'].invoke
        # Rake::Task['db:seed'].invoke

        # Rake::Task['rmonitor:app:update'].invoke
        # UpdateCommand.run

        # # run rake and setup tasks
        # system "bundle"
        # system "bundle exec rake db:create:all"
        # system "bundle exec rake db:migrate --trace"
      end

    end
  end
end