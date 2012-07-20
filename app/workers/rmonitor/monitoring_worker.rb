class RMonitor::MonitoringWorker
  include Sidekiq::Worker

  def perform(name, count)
    puts 'Doing hard work'
  end
end