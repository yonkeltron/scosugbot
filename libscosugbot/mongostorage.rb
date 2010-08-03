#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
Bundler.setup
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
          result = store(key, val)
        rescue Exception => e
          log(4, "#{result} -> #{e}", 'memory')
          result = e
        end
        result
      end

      def recall(key)
        begin
          result = fetch(key)
        rescue Exception => e
          result = e
          log(4, result, 'memory')
        end
        result
      end

      def store(key,val)
        result = fetch_raw(key, false)
        if result
          result = result.update_attributes!(:contents => val, :active => true)
          log(0, "Updating definition of #{key} with #{val}", 'memory')
        else
          result = Definition.create!(:term => key, :contents => val, :active => true)
        end
        result
      end

      def fetch(key)
        result = fetch_raw(key)
        if result
          result = result.contents
        end
        result
      end

      def fetch_raw(key, only_active = true)
        conds = {:term => key}
        if only_active
          conds[:active] = 'true'
        end
        Definition.first(:conditions => conds)
      end

      def delete(key)
        result = Definition.first(:conditions => {:term => key})
        if result
          result = result.destroy
        end
        result
      end

      def forget(key)
        result = fetch_raw(key) #Definition.first(:conditions => {:term => key, :active => 'true'})
        if result
          result = result.update_attributes(:active => false)
        end
        result
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

      def activate_all(sure = nil)
        if sure == true
          Definition.all.each do |d|
            d.update_attributes(:active => true)
            log(2, 'Activating defition: #{d.inspect}', 'memory')
            puts "Updated #{d.inspect}"
          end
        else
          log(2, 'Asked to activate all definitions but was not sure. Not doing anything.', 'memory')
          puts "Not sure so not activating all"
        end
      end

      def definition_count
        Definition.count
      end

      def log_count
        LogEntry.count
      end
    end

    class Definition
      include Mongoid::Document
      include Mongoid::Timestamps

      field :term, :type => String
      field :contents, :type => String
      field :active, :type => String, :default => true.to_s

      validates_presence_of :term, :contents, :active
      validates_uniqueness_of :term

      # index :term, :unique => true, :background => true
    end

    class LogEntry
      include Mongoid::Document
      include Mongoid::Timestamps

      field :message, :type => String
      field :priority, :type => Integer
      field :service, :type => String

      validates_presence_of :message, :priority, :service
      validates_numericality_of :priority

      def to_s
        "Message: #{self.message} | Priority: #{self.priority} | Service: #{self.service} <- Logged at #{self.created_at}"
      end
    end
  end
end
