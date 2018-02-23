# Copyright 2017-10-27
# Remy BOISSEZON boissezon.remy@gmail.com
# Valentin PRODHOMME valentin@prodhomme.me
# Dylan TROLES chill3d@protonmail.com
# Alexandre ZANNI alexandre.zanni@engineer.com
#
# This software is governed by the CeCILL license under French law and
# abiding by the rules of distribution of free software.  You can  use,
# modify and/ or redistribute the software under the terms of the CeCILL
# license as circulated by CEA, CNRS and INRIA at the following URL
# "http://www.cecill.info".
#
# The fact that you are presently reading this means that you have had
# knowledge of the CeCILL license and that you accept its terms.

require 'canvas_oss/event/version'
require 'syslog/logger'

module CanvasOss
  module Event
    # Class that log message using syslog
    # @example Create connection, send warning log, and close connection
    #   example_log = CanvasOss::Event::Logger.new('canvas_web', 1)
    #   example_log.log('warn', 'This is a warning log text')
    #   example_log.close
    # @author Dylan TROLES
    class Logger
      # Table of Syslog facilities constants
      FACILITIES = [Syslog::LOG_LOCAL0, Syslog::LOG_LOCAL1, Syslog::LOG_LOCAL2,
                    Syslog::LOG_LOCAL3, Syslog::LOG_LOCAL4, Syslog::LOG_LOCAL5,
                    Syslog::LOG_LOCAL6, Syslog::LOG_LOCAL7].freeze
      # Initialize Syslog::Logger class with a private call to {#connect}.
      # @param program_name [String] This parameter is the name of the programname in syslog
      # @param facility [Integer] Number of the Syslog facility local, where the integer is the postion of the facility in {CanvasOss::Event::Logger::FACILITIES} array
      # @example
      #   example_log = CanvasOss::Event::Logger.new('canvas_web', 3) # 3 for Syslog::LOG_LOCAL3
      def initialize(program_name, facility)
        connect(program_name, facility)
      end

      # Send logs thrue Syslog connection
      # @param severity [String] Severity of the log (unknown, error, warn, info, debug)
      # @param message [String] Content of the log
      # @example
      #   example_log.log('warn', 'This is a warning log text')
      #   example_log.log('info', 'This is a info log text')
      def log(severity, message)
        raise ArgumentError, 'Message must be a String' unless message.is_a?(String)
        begin
          case severity
          when 'alert'
            @log.unknown '[Alert] : ' + message
          when 'error'
            @log.error '[Error] : ' + message
          when 'warn'
            @log.warn '[Warning] : ' + message
          when 'info'
            @log.info '[Info] : ' + message
          when 'debug'
            @log.debug '[Debug] : ' + message
          else
            raise "You've provided a false severity name. Choose between : alert,
                  error, warn, info, debug."
          end
        rescue RuntimeError => exception
          raise "#{exception}. Syslog opened status : #{Syslog::Logger.syslog.opened?} "
        end
      end

      # Close connection if there is one opened. If not, raise error.
      def close
        begin
          Syslog::Logger.syslog.close
        rescue RuntimeError => exception
          raise "There is no Syslog connection to close : #{exception}"
        end
        return true
      end

      private

      # Initialize Syslog::Logger class. Called by {#initialize}.
      # @param program_name [String] This parameter is the name of the programname in syslog
      # @param facility [Integer] Number of the Syslog facility local, where the integer is the postion of the facility in {CanvasOss::Event::Logger::FACILITIES} array
      # @example
      #   example_log = CanvasOss::Event::Logger.new('canvas_web', 3) # 3 for Syslog::LOG_LOCAL3
      def connect(program_name, facility)
        raise ArgumentError, "You need to provide a number between 0 and #{FACILITIES.length - 1}" unless facility.is_a?(Integer) && facility.between?(0, FACILITIES.length - 1)
        raise ArgumentError, 'Program name must be a String' unless program_name.is_a?(String)
        begin
          @log = Syslog::Logger.new(program_name, FACILITIES[facility])
        rescue StandardError => exception
          raise "Syslog connection has failed : #{exception}"
        end
      end
    end
  end
end
