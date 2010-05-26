require 'rubygems'
require 'spec'
require 'libscosugbot'

describe LibScosugBot::Storage::CouchStore do

  before(:each) do 
    @host = "localhost"
    @port = "5984"
    @dbname = "rspec-test"
    @cs = LibScosugBot::Storage::CouchStore.new(@host, @port, @dbname)
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
