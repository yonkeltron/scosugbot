require 'rubygems'
require 'spec'
require 'couchrest'
require 'yaml'

config = YAML.load_file('config.yml')
COUCHHOST = config['couchdb']['host']
COUCHPORT = config['couchdb']['port']
TESTDB = 'scosugbot-test'
TEST_SERVER = CouchRest.new
TEST_SERVER.default_database = TESTDB
DB = TEST_SERVER.database(TESTDB)

Spec::Runner.configure do |config|
#  config.after(:all) do
#    TEST_SERVER.database(TESTDB).delete! #rescue nil
#  end
end
