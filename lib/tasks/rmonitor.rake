require 'rmonitor'

namespace :rmonitor do

  namespace :app do


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
  end

  # desc "Execute monitoring for all servers"
  # task :monitorings => :environment do
  #   require 'rmonitor/workers/monitorings_worker'
  #   RMonitor::Workers::MonitoringsWorker.perform_async
  # end

  Dir["#{Rails.root}/lib/rmonitor/workers/*.{rb}"].each do |source|
    filename     = File.basename(source).split("_").first
    require "rmonitor/workers/#{filename}_worker"
    task_name = "RMonitor::Workers::#{filename.camelize}Worker"
    task      = (task_name.constantize).new unless defined?(task_name.constantize.to_s).nil?

    if task
      src = <<-END_SRC
      desc "#{task.desc}"
      task "#{filename}" => :environment do
        require 'rmonitor/workers/#{filename}_worker'
        #{task.class.name.to_s}.perform_async
      end
      END_SRC
      self.class.class_eval src, __FILE__, __LINE__
    end
  end

end
