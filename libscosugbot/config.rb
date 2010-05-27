#!/usr/bin/env

require 'yaml'

module LibScosugBot
  class Config
    def self.couch 
      config = YAML.load_file('config.yml')
      "http://#{config['couchdb']['host']}:#{config['couchdb']['port']}/#{config['couchdb']['db']}"
    end
  end
end
