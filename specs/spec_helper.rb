require 'rubygems'
require 'spec'
require 'yaml'
require 'mongoid'

DBNAME = 'scosugbot-test'
DBPORT = 27017
DBHOST = 'localhost'

Spec::Runner.configure do |config|
  config.after(:all) do
    Mongo::Connection.new(DBHOST, DBPORT).drop_database(DBNAME)
  end
end
