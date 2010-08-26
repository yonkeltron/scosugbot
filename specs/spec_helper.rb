require 'rubygems'
require 'bundler'
Bundler.setup
require_relative '../libscosugbot'
require 'factory_girl'

Factory.find_definitions
Dir.glob(File.dirname(__FILE__) + "/factories/*.rb").each do |factory|
  require factory
end

DBNAME = 'scosugbot-test'
DBPORT = 27017
DBHOST = 'localhost'

Spec::Runner.configure do |config|
  config.after(:all) { Mongo::Connection.new(DBHOST, DBPORT).drop_database(DBNAME) }
end

def generate_presence_specs(model, props)
  Proc.new do
  include LibScosugBot::Storage
    props.each do |prop|
      it "should fail without #{prop}" do
        mod = Factory.build(model, prop => nil)
        mod.should_not be_valid
      end
    end
  end
end
