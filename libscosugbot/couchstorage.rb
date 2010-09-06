#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
Bundler.setup
require 'couch_potato'

module LibScosugBot
  module Storage
    class CouchStorage < GenericStore
      
      def initialize(dbname, host = 'localhost', port = '5984', username = nil, password = nil)
        auth_string = (username && password) ? "#{username}:#{password}@" : ''
        CouchPotato::Config.database_name = "http://#{auth_string}#{host}:#{port}/#{dbname}"
        CouchPotato::Config.validation_framework = :active_model
      end

      def store(key, val)
      end

      def fetch_raw(key, only_active = true)
      end

      def delete(key)
      end

      def forget(key)
      end
    end
  end
end
