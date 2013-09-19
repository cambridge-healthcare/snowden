require "redis"

module Snowden
  module Backends
    class RedisBackend
      #Creates a new redis backend
      #
      # @param namespace [String] the string this backend is namespaced under.
      # @param redis     [Redis] a Redis object instance to talk to a redis
      #                          database.
      def initialize(namespace="", redis=Redis.new(:driver => :hiredis))
        @namespace = namespace
        @redis     = redis
      end

      #Saves a value in this index
      #
      # @param key   [String] the string key to save the value under.
      # @param value [String] the value to save.
      def save(key, value)
        redis.lpush(namespaced_key(key), value)
        nil
      end

      #Finds a value in this index
      #
      # @param key [String] the string key to search the index for.
      # @return [ [String] ] a list of strings that matched the namespaced key.
      def find(key)
        redis.lrange(namespaced_key(key), 0, -1)
      end

      private

      def namespaced_key(key)
        namespace + ":" + key
      end

      attr_reader :redis, :namespace
    end
  end
end
