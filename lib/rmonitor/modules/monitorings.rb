require 'abstract_module'

module RMonitor
  module Modules
    module Monitorings
      include AbstractModule

      class Base
        def self.configs
          []
        end

        def self.definition
          []
        end
      end
    end
  end
end
