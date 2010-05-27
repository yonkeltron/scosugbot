#!/usr/bin/env

require 'rubygems'
require 'yaml'
require 'relaxdb'

module LibScosugBot
  class Config
    def self.couch 
      @config ||= YAML.load_file('config.yml')['couchdb']
      RelaxDB.configure :host => @config['host'], :port => @config['port']
      RelaxDB.use_db @config['db']
      RelaxDB.enable_view_creation
      RelaxDB::View.design_doc.save
      @config
    end
  end
end

