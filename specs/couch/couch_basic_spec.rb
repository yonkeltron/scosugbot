require 'libscosugbot'
require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe LibScosugBot::Storage::CouchStore do

  before(:each) do 
    @host = COUCHHOST
    @port = COUCHPORT
    @dbname = TESTDB
    @cs = LibScosugBot::Storage::CouchStore.new(@host, @port, @dbname)
  end

  after(:each) do
    @cs.db.delete! #rescue nil
  end

  describe "should assign config variables properly with readers" do

    it "and provide host reader" do
      @cs.should respond_to(:host)
    end

    it "and assign host properly" do
      @cs.host.should eql(@host)
    end

    it "and provide port reader" do
      @cs.should respond_to(:port)
    end

    it "and assign port properly" do
      @cs.port.should eql(@port)
    end

    it "and provide dbname reader" do
      @cs.should respond_to(:dbname)
    end

    it "and assign dbname properly" do
      @cs.dbname.should eql(@dbname)
    end

  end
end
