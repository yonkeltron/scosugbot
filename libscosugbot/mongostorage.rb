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
          Definition.create!(:term => key, :contents => val)
        end

        def fetch(key)
          result = Definition.first(:conditions => {:term => key})
          if result
              result = result.contents
          end
          result
        end

        def log(message, priority, service = 'system')
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
