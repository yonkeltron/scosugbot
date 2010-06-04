#!/usr/bin/env ruby

module LibScosugBot
  module Views
    class MemorizationSnippets
      def self.forget_snippet(thing, success)
        if success
          rep = "Forgot #{thing}"
        else
          rep = "Could not forget #{thing}. Was it ever defined?" 
        end
        rep
      end

      def self.memorize_snippet(thing, success, exception = nil)
        if exception
          rep = "Problem storing #{thing}: #{exception}"
        elsif success
          rep = "Got it."
        else
          rep = "FAIL while storing #{thing}!"
        end
        rep
      end
    end
  end
end
