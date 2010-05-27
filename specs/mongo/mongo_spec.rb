require 'libscosugbot'
require 'specs/spec_helper'

describe LibScosugBot::Storage::MongoDB::MongoStore do

  before(:each) do 
    @dbname = DBNAME
    @dbhost = DBHOST
    @dbport = DBPORT

    @db = LibScosugBot::Storage::MongoDB::MongoStore.new(@dbname, @dbhost, @dbport)

    @test_vals = {
      'panda' => 'bamboo',
      'chicken' => 'curry',
      'noodle' => 'irrational',
      'monkey' => 'exhuberant'
    }

    @test_log_vals = {
      1 => ['panda', 'bamboo'],
      2 => ['curry', 'noodle'],
      3 => ['chicken', 'delicious'],
      4 => ['irrational', 'monkey'],
      5 => ['exhuberant', 'potato']
    }
  end

  it "should instantiate properly" do
    @db.should be_instance_of(LibScosugBot::Storage::MongoDB::MongoStore)
  end

  describe "should handle storage effectively" do
    it "and should memorize successfully" do
      @test_vals.each_pair do |k,v|
        @db.memorize(@k, @v).should be_true
      end
    end

    it "and should recall successfully" do
      @test_vals.each_pair do |k,v|
        @db.memorize(k,v)
        @db.recall(k).should eql(v)
      end
    end

    it "and should return nil when a record is not found" do
      @db.recall('FROG').should be_nil
    end
  end

  describe "should log properly" do
    it "and log without error" do
      pending
    end
  end
end