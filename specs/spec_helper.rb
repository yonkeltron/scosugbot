require 'rubygems'
require 'spec'
require 'couchrest'

COUCHHOST = "localhost"
COUCHPORT = "5984"
TESTDB = 'scosugbot-test'
TEST_SERVER = CouchRest.new
TEST_SERVER.default_database = TESTDB
DB = TEST_SERVER.database(TESTDB)

Spec::Runner.configure do |config|
#  config.after(:all) do
#    TEST_SERVER.database(TESTDB).delete! #rescue nil
#  end
end
