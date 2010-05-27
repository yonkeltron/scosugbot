#!/usr/bin/env ruby

require 'rubygems'
require 'couchrest'

module LibScosugBot
  module Storage
    class CouchStore
      attr_reader :host, :dbname, :port, :db
      def initialize(host, port, dbname)
        @host = host
        @port = port
        @dbname = dbname
        @db = CouchRest.database!("http://#{@host}:#{@port}/#{@dbname}")
      end
    end

    class Definition < CouchRest::ExtendedDocument
      include CouchRest::Validation
      
      use_database CouchRest.database!(LibScosugBot::Config.couch)

      property :type, :read_only => true
      
      property :name
      property :definitions, :cast_as => ['String']

      timestamps!

      validates_presence_of :name
      validates_presence_of :definitions
    end
  end
end
