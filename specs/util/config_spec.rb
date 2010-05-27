require 'libscosugbot'
require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe LibScosugBot::Config do

  before(:each) do 
    @host = COUCHHOST
    @port = COUCHPORT
    @dbname = TESTDB
  end

  it '#couch should return a proper couchdb URL' do
    name = @dbname.gsub(/-test/, '')
    LibScosugBot::Config.couch.should eql("http://#{@host}:#{@port}/#{name}")
  end
end
