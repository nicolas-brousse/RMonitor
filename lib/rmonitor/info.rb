module RMonitor
  module Info #:nodoc:
    class << self
      def app_name; 'RMonitor' end
      def url; 'https://github.com/nicolas-brousse/RMonitor/' end
      def help_url; 'https://github.com/nicolas-brousse/RMonitor/wiki' end
      def versioned_name; "#{app_name} #{RMonitor::VERSION}" end

      def environment
        s = "Environment:\n"
        s << [
          ["RMonitor version", RMonitor::VERSION],
          ["Ruby version", "#{RUBY_VERSION} (#{RUBY_PLATFORM})"],
          ["Rails version", Rails::VERSION::STRING],
          ["Environment", Rails.env],
          ["Database adapter", ActiveRecord::Base.connection.adapter_name]
        ].map {|info| "  %-40s %s" % info}.join("\n")
      end
    end
  end
end