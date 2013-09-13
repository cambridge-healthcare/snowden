module Snowden
  module Backends
    class HashBackend
      def initialize(hash={})
        @hash = hash
      end

      def save(key, value)
        @hash[key] ||= []
        @hash[key] << value
      end

      def find(key)
        @hash.fetch(key, [])
      end
    end
  end
end
