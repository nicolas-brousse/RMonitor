require 'rmonitor'

namespace :rmonitor do

  namespace :app do

    desc "Install RMonitor"
    task :install => :environment do
      # TODO - Execute rake cmd
      #
      #    * rake db:setup
      #    * rake db:migrate
      #

      puts "Install RMonitor Database for #{Rails.env} env"
      # Rake::Task['db:setup'].invoke
      Rake::Task['db:migrate'].invoke
      Rake::Task['db:seed'].invoke

      Rake::Task['rmonitor:app:update'].invoke
    end

    desc "Update RMonitor"
    task :update => :environment do
      # TODO - Execute rake cmd
      #
      #    * rake db:setup
      #    * rake db:migrate
      #

      puts "Update RMonitor Application"
      `cd #{Rails.root} && git pull origin`
      `cd #{Rails.root} bundle install`

      puts "Update RMonitor Database for #{Rails.env} env"
      Rake::Task['db:migrate'].invoke
      # Rake::Task['db:seed'].invoke

      puts ""
      puts "Now configure your cronjob"
      puts "  5 * * * * cd #{Rails.root} && /full/path/to/rvm/bin/rake RAILS_ENV=#{Rails.env} -f Rakefile rmonitor:monitorings"
    end

    desc "Version of RMonitor Application"
    task :version => :environment do
      puts ""
      puts "Version:"
      puts "  " + RMonitor::Info.versioned_name
      puts ""
      puts RMonitor::Info.environment
      puts ""
    end

  end

  desc "Execute monitoring for all servers"
  task :monitorings => :environment do
    require 'rmonitor/tasks/monitorings'
    RMonitor::Tasks::Monitorings.perform_async
  end

end
