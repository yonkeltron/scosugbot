

module LibScosugBot
  module Storage
    class GenericStore

      def memorize(key,val)
        begin
          result = store(key, val)
        rescue Exception => e
          log(4, "#{result} -> #{e}", 'memory')
          result = e
        end
        result
      end

      def recall(key)
        begin
          result = fetch(key)
        rescue Exception => e
          result = e
          log(4, result, 'memory')
        end
        result
      end

      def fetch(key)
        result = fetch_raw(key)
        if result
          result = result.contents
        end
        result
      end

    end
  end
end
