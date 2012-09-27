module RMonitor
  module Commands

    class Base
      def self.register_command(options = {})
        define_method(:name)        { options[:name] }
        define_method(:description) { options[:description] }
      end

      def self.run
        obj = self.new
        obj.run
      end

      def run
        raise Exception, "Command '#{self.clas.name}' invalid"
      end
    end

  end
end