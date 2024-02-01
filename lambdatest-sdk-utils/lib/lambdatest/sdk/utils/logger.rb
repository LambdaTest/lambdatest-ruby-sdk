require "logger"
require_relative "constants"

module Lambdatest
  module Sdk
    module Utils        
      def self.log_level
        if ENV['LT_SDK_DEBUG'] == 'true'
          Logger::DEBUG
        else
          log_level_str = ENV.fetch('LT_SDK_LOG_LEVEL', 'info').downcase
          case log_level_str
          when 'debug'
            Logger::DEBUG
          when 'warning'
            Logger::WARN
          when 'error'
            Logger::ERROR
          when 'critical'
            Logger::FATAL
          else
            Logger::INFO
          end
        end
      end
        
      def self.get_logger
        logger = Logger.new(STDOUT)
        logger.level = log_level
        logger.progname = get_pkg_name
        logger
      end
    end
  end
end
  