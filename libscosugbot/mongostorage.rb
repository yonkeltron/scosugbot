#!/usr/bin/env ruby

require 'rubygems'
require 'mongoid'

module LibScosugBot
  module Storage
    class MongoStore
      attr_accessor :db
      
      def initialize(dbname, host = 'localhost', port = '27017')
        @db = Mongo::Connection.new(host, port).db(dbname)
        Mongoid.configure do |config|
          config.master = @db
        end
        log(0, "Starting Up at #{Time.now}")
      end
      
      def memorize(key,val)
        begin
          success = store(key, val)
          if success
            result = "Got it."
          else
            result = "FAIL while storing #{key}!"
          end
        rescue Exceptopn => e
          log(4, "#{result} -> #{e}", 'memory')
          result = "Problem storing #{key}: #{e}"
        end
        result
      end

      def recall(key)
        begin
          success = fetch(key)
          if success
            result = "#{key} is #{success}"
          else
            result = "I don't know what #{key} is"
          end
        rescue Exception => e
          result = "Error retrieving #{key}: #{e}"
          log(4, result, 'memory')
        end
        result
      end

      def store(key,val)
        result = fetch_raw(key)
        if result
          result.contents = val
          log(0, "Updating definition of #{key} with #{val}", 'memory')
        else
          result = Definition.new(:term => key, :contents => val)
        end
        result.save
      end

      def fetch(key)
        result = fetch_raw(key)
        if result
          result = result.contents
        end
        result
      end

      def fetch_raw(key)
        Definition.first(:conditions => {:term => key})
      end

      def log(priority, message, service = 'system')
        begin
          LogEntry.create!(:message => message, :priority => priority, :service => service)
        rescue Exception => e
          puts "Error saving log entry! Time: #{Time.now} -> #{e}"
        end
      end

      def last_log_message
        LogEntry.last
      end
    end

    class Definition
      include Mongoid::Document
      include Mongoid::Timestamps

      field :term, :type => String
      field :contents, :type => String

      #index :term, :background => true
    end

    class LogEntry
      include Mongoid::Document
      include Mongoid::Timestamps

      field :message, :type => String
      field :priority, :type => Integer
      field :service, :type => String

      def to_s
        "Message: #{self.message} | Priority: #{self.priority} | Service: #{self.service} <- Logged at #{self.created_at}"
      end
    end
  end
end


