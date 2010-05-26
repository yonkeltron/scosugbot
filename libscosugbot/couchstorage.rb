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

  end
end
