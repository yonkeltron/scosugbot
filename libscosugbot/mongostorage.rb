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
          Mongoid.configure do |config|
            config.master = @db
          end
        end

        def memorize(key,val)
          Definition.create!(:term => key, :contents => val)
        end

        def recall(key)
          Definition.first(:conditions => {:term => key})
        end

        def log(message, priority, service = 'system')
        end

      end

      class Definition
        include Mongoid::Document
        include Mongoid::Timestamps

        field :term, :type => String
        field :contents, :type => String

        index :term, :background => true
      end
    end
  end
end
