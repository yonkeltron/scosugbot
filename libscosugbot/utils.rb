#!/usr/bin/env ruby

require 'json'
require 'net/http'

module LibScosugBot
  module Utils
    class Twitter
      def self.get_last_twitter_statuses_as_hash(username, count = 1)
        JSON.parse(self.get_raw_json_string(username, count))
      end

      def self.get_raw_json_string(username, count = 1)
        Net::HTTP.get(URI.parse(self.twitter_url(username, count)))
      end

      def self.twitter_url(username, count = 1)
        "http://api.twitter.com/1/statuses/user_timeline/#{username}.json?count=#{count}"
      end
    end
  end
end
