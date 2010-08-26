#!/usr/bin/env ruby
require 'spec/spec_helper'

describe LibScosugBot::Utils::Twitter do

  before(:each) do
    @uname = 'panda'
    @count = 3
    @vals = {
      'panda' => 2,
      'bamboo' => 1,
      'curry69' => 4,
      'noodle613' => 10
    }
  end

  describe "#twitter_url should format urls correctly" do
    it "should format count properly" do
      @vals.each_pair do |k,v|
        LibScosugBot::Utils::Twitter.twitter_url(k,v).should match(Regexp.new("count=#{v}"))
      end
    end

    it "should format usernames correctly" do
      @vals.each_pair do |k,v|
        LibScosugBot::Utils::Twitter.twitter_url(k,v).should match(Regexp.new("/#{k}.json?"))
      end
    end
  end
end
