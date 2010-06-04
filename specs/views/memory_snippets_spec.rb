#!/usr/bin/env ruby
require 'specs/spec_helper'

describe LibScosugBot::Views::MemorizationSnippets do

  before(:each) do
    @thing = 'PANDA'
    @val = 'BAMBOO'
  end

  describe "#forget_snippet" do
    it "and should respond to #forget_snippet" do
      LibScosugBot::Views::MemorizationSnippets.should respond_to(:forget_snippet)
    end

    it "and should respond properly on success" do
      LibScosugBot::Views::MemorizationSnippets.forget_snippet(@thing, true).should eql("Forgot #{@thing}")
    end

    it "and should respond properly on failure" do
      LibScosugBot::Views::MemorizationSnippets.forget_snippet(@thing, false).should eql( "Could not forget #{@thing}. Was it ever defined?" )
    end
  end

  describe "#memorize_snippet" do
    it "and should respond to #memorize_snippet" do
      LibScosugBot::Views::MemorizationSnippets.should respond_to(:memorize_snippet)
    end

    it "and should respond properly on success" do
      LibScosugBot::Views::MemorizationSnippets.memorize_snippet(@thing, true).should eql("Got it.")
    end

    it "and should respond properly on failure" do
      LibScosugBot::Views::MemorizationSnippets.memorize_snippet(@thing, false).should eql("FAIL while storing #{@thing}!")
    end
    
    it "and should respond properly on exception" do
      LibScosugBot::Views::MemorizationSnippets.memorize_snippet(@thing, false, @val).should eql("Problem storing #{@thing}: #{@val}")
    end
  end

end
