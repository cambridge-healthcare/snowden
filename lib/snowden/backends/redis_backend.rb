require "redis"

module Snowden
  class RedisBackend
    def initialize(namespace="", redis=Redis.new(:driver => :hiredis))
      @namespace = namespace
      @redis = redis
    end

    def save(key, value)
      redis.lpush(namespaced_key(key), value)
    end

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
