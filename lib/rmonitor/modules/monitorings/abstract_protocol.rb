module RMonitor
  module Modules
    module Monitorings
      class AbstractProtocol

        def self.execute
          throw Exception.new("FATAL: #{self.class.name.to_s} don't include self.execute() function!")
        end

      end
    end
  end
end