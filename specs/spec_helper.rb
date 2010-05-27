require 'rubygems'
require 'spec'
require 'couchrest'
require 'yaml'

config = YAML.load_file('config.yml')
unless defined?(COUCHHOST)
  COUCHHOST = config['couchdb']['host']
end
unless defined?(COUCHPORT)
  COUCHPORT = config['couchdb']['port']
end
unless defined?(TESTDB)
  TESTDB = 'scosugbot-test'
end
unless defined?(TEST_SERVER)
  TEST_SERVER = CouchRest.new
  TEST_SERVER.default_database = TESTDB
end
