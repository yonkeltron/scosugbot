require 'libscosugbot'
require 'specs/spec_helper'

describe LibScosugBot::Storage::MongoStore do

  before(:each) do 
    @dbname = DBNAME
    @dbhost = DBHOST
    @dbport = DBPORT

    @db = LibScosugBot::Storage::MongoStore.new(@dbname, @dbhost, @dbport)

    @test_log_vals = {
      1 => ['panda', 'bamboo'],
      2 => ['curry', 'noodle'],
      3 => ['chicken', 'delicious'],
      4 => ['irrational', 'monkey'],
      5 => ['exhuberant', 'potato']
    }
  end

  describe "should log properly" do
    it "and log without error" do
      @test_log_vals.each_pair do |k,v|
        @db.log(k, v[0], v[1]).should be_true
      end
    end

    it "and get last LogEntry object for #last_log_message" do
      @db.log(1, 'panda', 'bamboo')
      @db.last_log_message.should be_instance_of(LibScosugBot::Storage::LogEntry)
      @db.last_log_message.priority.should eql(1)
      @db.last_log_message.message.should eql('panda')
      @db.last_log_message.service.should eql('bamboo')
    end

    describe "and produce pretty output upon string conversion" do
      before(:each) do
        @dbname = DBNAME
        @dbhost = DBHOST
        @dbport = DBPORT
        
        @db = LibScosugBot::Storage::MongoStore.new(@dbname, @dbhost, @dbport)
        
        @db.log(1, 'panda', 'bamboo')
      end

      it "and format messages properly" do
        @db.last_log_message.to_s.should match(/Message: panda/)
      end

      it "and format priority properly" do
        @db.last_log_message.to_s.should match(/Priority: 1/)
      end

      it "and format service properly" do
        @db.last_log_message.to_s.should match(/Service: bamboo/)
      end
      
      it "and utilize pipes as separators" do
        @db.last_log_message.to_s.count('|').should eql(2)
      end

      it "and have a text arrow for timestamp pointer" do
        @db.last_log_message.to_s.should match(/<-/)
      end
    end
  end

  describe "should validate properly" do
    describe "and validate presence" do
      generate_presence_specs(:log_entry, [:message, :priority, :service]).call
    end

    it "and fail on non-numerical priority" do
      le = Factory.build :log_entry, :priority => []
      le.should_not be_valid
    end
  end
end
