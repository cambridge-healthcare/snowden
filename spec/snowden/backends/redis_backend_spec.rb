require "spec_helper"
require "snowden"
require "redis_gun"

module Snowden::Backends
  describe RedisBackend do
    subject(:backend) { RedisBackend.new("namespace", redis_connection_helper) }
    let(:redis_connection) { RedisGun::RedisServer.new.tap {|x| x.running? } }

    describe "#save" do
      it "returns nil" do
        expect(backend.save("key", "value")).to be nil
      end
    end

    describe "#find" do
      it "finds the value stored under the key in redis" do
        redis_connection_helper.lpush("namespace:bacon", "troll")
        expect(backend.find("bacon")).to eq(["troll"])
      end
    end

    describe "saving and finding" do
      it "can find values it has saved" do
        backend.save("key", "value")
        expect(backend.find("key")).to eq(["value"])
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
