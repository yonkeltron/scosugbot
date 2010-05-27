#!/usr/bin/env ruby

require 'rubygems'
require 'mongoid'
require 'mongo'

module LibScosugBot
  module Storage
    module MongoDB
      class MongoStore
        attr_accessor :db

        def initialize(dbname, host = 'localhost', port = '27017')
          @db = Mongo::Connection.new(host, port).db(dbname)
#          LibScosugBot::Config.mongo(@db)
          Mongoid.configure do |config|
            config.master = @db
          end
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
            result = "Problem storing #{key}: #{e}"
          end
          result
        end

        def recall(key)
          begin
            success = fetch(key)
            if success
              result = "I recall that #{key} is #{success}"
            else
              result = "I don't know what #{key} is"
            end
          rescue Exception => e
            result = "Error retrieving #{key}: #{e}"
          end
          result
        end

        def store(key,val)
          result = fetch_raw(key)
          if result
            result.contents = val
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
            LogEntry.create!(:message => message, :priority => priority, :service => 'system')
          rescue Exception => e
            puts "Error saving log entry! Time: #{Time.now} -> #{e}"
          end
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
      end
    end
  end
end
