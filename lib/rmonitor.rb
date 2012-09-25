require 'rmonitor/info'
require 'rmonitor/logging'
require 'rmonitor/modules'
require 'rmonitor/version'

# begin
#   require_library_or_gem 'RMagick' unless Object.const_defined?(:Magick)
# rescue LoadError
#   # RMagick is not available
# end

module RMonitor

  def self.logger
    RMonitor::Logging.logger
  end

  def self.logger=(log)
    RMonitor::Logging.logger = log
  end
end