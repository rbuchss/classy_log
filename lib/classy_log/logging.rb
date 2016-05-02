require 'logger'
require 'pp'

module ClassyLog
  module Logging
    extend ClassAttrs
    class_attr_accessor :pretty_print_mode, :global_level
    class_attr_reader :logs

    ORIGINAL_FORMATTER = Logger::Formatter.new
    DEFAULT_LOG_LEVEL = Logger::INFO
    @@global_level = DEFAULT_LOG_LEVEL
    @@pretty_print_mode = false
    @@logs = {}

    def self.included(base)
      base.extend ClassMethods
    end

    def log
      if @@logs[self.class.name].nil? && @log
        @@logs[self.class.name] = @log
      end
      @log ||= Logging.log_for(self.class.name)
    end

    def log=(log)
      @log = log
    end

    module ClassMethods
      def log
        @@log ||= Logging.log_for(name)
      end

      def log=(log)
        @@log = log
      end
    end

    class << self
      def log_for(classname)
        @@logs[classname] ||= configure_log_for(classname)
      end

      def configure_log_for(classname, log=Logger.new(STDOUT))
        log.level = @@global_level
        log.progname = classname
        log.formatter = proc do |severity, datetime, progname, msg|
          if msg.is_a?(String) or not @@pretty_print_mode
            ORIGINAL_FORMATTER.call(severity, datetime, progname, msg)
          else
            ORIGINAL_FORMATTER.call(severity, datetime, progname, PP.pp(msg, ''))
          end
        end
        log
      end

      def global_level=(level)
        @@logs.each { |_,log| log.level = level }
        @@global_level = level
      end
    end
  end # Logging
end # ClassyLog
