module Snowden
  module Backends
    SNOWDEN_BACKEND_HASH = {}

    class HashBackend
      def initialize(namespace="", hash=SNOWDEN_BACKEND_HASH)
        @namespace = namespace
        @hash      = hash
      end

      def save(key, value)
        @hash[namespaced_key(key)] ||= []
        @hash[namespaced_key(key)] << value
        nil
      end

      def find(key)
        @hash.fetch(namespaced_key(key), [])
      end

      private

      def namespaced_key(key)
        [@namespace, key]
      end
    end
  end
end
