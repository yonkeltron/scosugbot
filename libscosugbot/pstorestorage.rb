#!/usr/bin/env ruby

require 'pstore'

module LibScosugBot
  module Storage
    class PStoreStore
      def initialize(filename)
        @db = PStore.new(filename)
      end
      
      def memorize(key,val)
        @db.transaction do
          @db[key.to_s.downcase] = val
        end
        "Got it!"
      end
      
      def recall(key)
        recollection = []
        @db.transaction(true) do
          recollection.push(@db[key.to_s.downcase])
        end
        if recollection[0]
          the_reply = "I recall that #{key} is #{recollection[0]}"
        else
          the_reply = "I don't know what #{key} is..."
        end
        the_reply
      end
    end
  end
end
