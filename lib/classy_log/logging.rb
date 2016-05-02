require 'logger'
require 'pp'

module ClassyLog
  module Logging
    extend ClassAttrs
    class_attr_accessor :pretty_print, :global_level

    def self.included(base)
      base.extend ClassMethods
    end

    def log
      @log ||= Logging.log_for(self.class.name)
    end

    def log=(log)
      @log = log
    end

    @@global_level = Logger::INFO
    @@pretty_print = false
    @@logs = {}

    class << self
      ORIGINAL_FORMATTER = Logger::Formatter.new

      def log_for(classname)
        @@logs[classname] ||= configure_log_for(classname)
      end

      def configure_log_for(classname)
        log = Logger.new(STDOUT)
        log.level = @@global_level
        log.progname = classname
        log.formatter = proc do |severity, datetime, progname, msg|
          if msg.is_a?(String) or not @@pretty_print
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

    module ClassMethods
      def log
        Logging.log_for(name)
      end
    end
  end # Logging
end # ClassyLog
