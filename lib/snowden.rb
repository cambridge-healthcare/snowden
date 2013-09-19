require "snowden/backends/hash_backend"
require "snowden/backends/redis_backend"
require "snowden/configuration"
require "snowden/crypto"
require "snowden/wildcard_generator"
require "snowden/encrypted_search_index"
require "snowden/encrypted_searcher"

module Snowden
  # A handle to the Snowden configuration object used elsewhere in the gem
  #
  # @return [Snowden::Configuration] the configuration object
  def self.configuration
    @configuration ||= Snowden::Configuration.new
  end

  # Creates a new index that will encrypt keys and values stored within it
  #
  # @param key [String]
  #   a bytestring key for the underlying encryption algorithm.
  #
  # @param iv  [String]
  #   a bytestring iv for the underlying encryption algorithm.
  #
  # @param backend [Snowden::Backend]
  #   an object that implements the snowden backend protocol.
  #
  # @return [Snowden::EncryptedSearchIndex]
  #   a snowden index to store values in.
  #
  def self.new_encrypted_index(key, iv, backend=configuration.backend)
    EncryptedSearchIndex.new(
      :crypto             => crypto_for(key, iv),
      :backend            => backend,
      :wildcard_generator => wildcard_generator,
    )
  end

  # Creates a new searcher for a snowden index
  #
  # @param key [String]
  #   a bytestring key for the underlying encryption algorithm.
  #   Note: the key and iv must match the ones passed to create the index
  #
  # @param iv [String]
  #   a bytestring iv for the underlying encryption algorithm.
  #   Note: the key and iv must match the ones passed to create the index
  #
  # @param index [Snowden::EncryptedSearchIndex]
  #   the index to search.
  #
  # @return [Snowden::EncryptedSearcher]
  #   a searcher for the index.
  def self.new_encrypted_searcher(key, iv, index)
    EncryptedSearcher.new(
      :crypto             => crypto_for(key, iv),
      :index              => index,
      :wildcard_generator => wildcard_generator,
    )
  end

  private

  def self.wildcard_generator
    WildcardGenerator.new(:edit_distance => configuration.edit_distance)
  end

  def self.crypto_for(key, iv)
    Crypto.new(
      :key          => key,
      :iv           => iv,
      :cipher_spec  => configuration.cipher_spec,
      :padding_size => configuration.padding_byte_size
    )
  end
end
