require 'rubygems'
require 'bundler'
Bundler.setup
require 'libscosugbot'
require 'specs/spec_helper'


describe LibScosugBot::Storage::Definition do

  before(:each) do
    @dbname = DBNAME
    @dbhost = DBHOST
    @dbport = DBPORT

    @db = LibScosugBot::Storage::MongoStore.new(@dbname, @dbhost, @dbport)
  end

  describe "should validate properly" do 
    generate_presence_specs(:definition, 
                            [:term, :contents, :active]).call
  end

end
