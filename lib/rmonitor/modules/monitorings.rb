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

      class << self
        def protocol_list
          ['ping', 'http']
        end

        def protocol_exists?(protocol)
          self.protocol_list.include? protocol
        end
      end
    end
  end
end
