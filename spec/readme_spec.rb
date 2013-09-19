require "spec_helper"
require "redis"
require 'snowden'

describe "the examples from the readme" do
  before do
    Redis.new(:driver => :hiredis).flushdb
  end

  it "works for the example in the usage section" do
    # 256 bit aes with 128 bit block
    aes_key = "a"*(256/8)
    aes_iv  = "b"*(128/8)

    index    = Snowden.new_encrypted_index(aes_key, aes_iv, Snowden::Backends::HashBackend.new("",{}))
    searcher = Snowden.new_encrypted_searcher(aes_key, aes_iv, index)

    index.store("bacon", "bits")

    # => ["bits"]
    expect(searcher.search("bac")).to eq(["bits"])
  end

  it "works for the example in the redis section" do
    redis = Redis.new(:driver => :hiredis)
    redis_backend = Snowden::Backends::RedisBackend.new("index_namespace", redis)

    aes_key = OpenSSL::Random.random_bytes(256/8)
    aes_iv = OpenSSL::Random.random_bytes(128/8)

    index = Snowden.new_encrypted_index(aes_key, aes_iv, redis_backend)
    index.store("bacon", "bits")

    searcher = Snowden.new_encrypted_searcher(aes_key, aes_iv, index)
    expect(searcher.search("bac")).to eq(["bits"])
  end

  it "works for the cipher_spec example in the configuration section" do
    Snowden.configuration.cipher_spec = "RC4"

    aes_key = "a"*(256/8)
    aes_iv  = "b"*(128/8)

    #Sometime later:
    index = Snowden.new_encrypted_index(aes_key, aes_iv, Snowden::Backends::HashBackend.new("",{}))
  end
end
