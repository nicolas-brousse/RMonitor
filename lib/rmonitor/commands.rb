require 'thor'
require 'thor/shell/basic'
require 'thor/shell/color'

module RMonitor
  module Commands

    def self.included(base)
      base.send :extend, ::Thor::Shell
      base.send :extend, ::Thor::Actions
    end

    class Base

      class << self
        def register_command(options = {})
          define_method(:name)        { options[:name] }
          define_method(:description) { options[:description] }
        end


        def run
          obj = self.new
          obj.run
        end
      end

      def shell
        @shell ||= ::Thor::Shell::Color.new
      end

      def exit message = "", color = [:white, :on_red]
        shell.say message, color
      end

      def run
        raise Exception, "Command '#{self.clas.name}' invalid"
      end
    end

  end
end