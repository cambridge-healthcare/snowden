require "spec_helper"
require "snowden"
require "redis_gun"

module Snowden
  describe RedisBackend do
    subject(:backend) { RedisBackend.new("namespace", redis_connection_helper) }
    let(:redis_connection) { RedisGun::RedisServer.new.tap {|x| x.running?} }

    describe "#save" do
      it "saves the key and value in redis" do
        backend.save("key", "value")
        expect(redis_connection_helper.lrange("namespace:key", 0, -1)).to eq(["value"])
      end
    end

    describe "#find" do
      it "finds the value stored under the key in redis" do
        redis_connection_helper.lpush("namespace:bacon", "troll")
        expect(backend.find("bacon")).to eq(["troll"])
      end
    end

    def redis_connection_helper
      Redis.new(:url => redis_connection.socket)
    end

    after do
      redis_connection.stop
    end
 end
end
