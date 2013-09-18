require "snowden/backends/hash_backend"
require "snowden/backends/redis_backend"
require "snowden/crypto"
require "snowden/wildcard_generator"
require "snowden/encrypted_search_index"
require "snowden/encrypted_searcher"

module Snowden
  DEFAULT_EDIT_DISTANCE = 3
  PADDING_BYTE_SIZE = 32

  @edit_distance = DEFAULT_EDIT_DISTANCE

  def self.edit_distance
    @edit_distance
  end

  def self.edit_distance=(arg)
    @edit_distance = arg
  end

  def self.new_encrypted_index(key, iv, backend)
    EncryptedSearchIndex.new(
      :crypto             => crypto_for(key, iv),
      :backend            => backend,
      :wildcard_generator => wildcard_generator,
    )
  end

  def self.new_encrypted_searcher(key, iv, index)
    EncryptedSearcher.new(
      :crypto             => crypto_for(key, iv),
      :index              => index,
      :wildcard_generator => wildcard_generator,
    )
  end

  private

  def self.wildcard_generator
    WildcardGenerator.new(:edit_distance => edit_distance)
  end

  def self.crypto_for(key, iv)
    Crypto.new(:key => key, :iv => iv)
  end
end
