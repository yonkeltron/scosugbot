require 'libscosugbot'
require 'specs/spec_helper'

describe LibScosugBot::Storage::MongoStore do

  before(:each) do 
    @dbname = DBNAME
    @dbhost = DBHOST
    @dbport = DBPORT

    @db = LibScosugBot::Storage::MongoStore.new(@dbname, @dbhost, @dbport)

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
    @db.should be_instance_of(LibScosugBot::Storage::MongoStore)
  end

  describe "should handle storage effectively" do
    it "and should store successfully" do
      @test_vals.each_pair do |k,v|
        ret = @db.store(k,v).should be_true
      end
    end

    it "and should set active to true on storage" do
      @db.store('panda', 'bamboo')
      LibScosugBot::Storage::Definition.first(:conditions => {:term => 'panda'}).active.should eql('true')
    end

    it "and should recall successfully" do
      @test_vals.each_pair do |k,v|
        @db.store(k,v)
        @db.fetch(k).should eql(v)
      end
    end

    it "and should return nil when a record is not found" do
      @db.fetch('FROG').should be_nil
    end

    it "and should respond properly to memorize" do
      @db.memorize('panda', 'bamboo').should be_true
    end

    it "and should respond properly to recall" do
      @db.memorize('panda', 'bamboo')
      @db.recall('panda').should be_true
    end

    it "and should deal with replacements properly" do
      @db.memorize('panda', 'bamboo')
      @db.memorize('panda', 'CURRY')
      @db.fetch('panda').should eql('CURRY')
    end

    it "and #fetch_raw should return whole objects" do
      @db.memorize('panda', 'bamboo')
      @db.fetch_raw('panda').should be_instance_of(LibScosugBot::Storage::Definition)
      @db.fetch_raw('panda').contents.should eql('bamboo')
    end

    it "and #delete should actually do deletion" do
      @db.memorize('panda', 'bamboo')
      LibScosugBot::Storage::Definition.find(:conditions => { :term => 'panda'}).should_not be_nil
      @db.delete('panda')
      @db.fetch_raw('panda').should be_nil
    end

    it "and #forget should just deactivate records" do
      @db.memorize('panda', 'bamboo')
      @db.forget('panda')
      LibScosugBot::Storage::Definition.first(:conditions => { :term => 'panda'}).active.should eql('false')

    end

    it "and #fetch_raw should not return deactivated definitions" do
      @db.memorize('panda', 'bamboo')
      @db.forget('panda')
      @db.fetch_raw('panda').should be_nil      
    end
  end
end
