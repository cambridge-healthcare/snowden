module Snowden
  class EncryptedSearchIndex
    #Creates a new search index
    #
    # @param args [Hash]
    #   A hash that must contain the following keys:
    #     * :crypto - an instance of Snowden::Crypto primed with some key and
    #                 iv
    #     * :backend - a Snowden::Backends compatible backend.
    #     * :wildcard_generator - an instance of Snowden::WildcardGenerator
    def initialize(args)
      @crypto             = args.fetch(:crypto)
      @backend            = args.fetch(:backend)
      @wildcard_generator = args.fetch(:wildcard_generator)
    end

    #Stores a value under the key
    #
    # @param key [String] the key to store the value under
    # @param value [String] the value to store in the key
    #
    # @return nil
    def store(key, value)
      wildcard_generator.wildcards(key).each do |wildcard|
        backend.save(encrypt_key(wildcard), encrypt_value(value))
      end
      nil
    end

    # Looks up the key in the backend
    #
    # @api private
    #
    # @param key [String] the key to look up in the backend. Note: the key does
    #                     not have wildcarding applied to it. Calling this
    #                     method directly is probably a bad idea.
    def search(key)
      backend.find(key)
    end

    private

    attr_reader :backend, :crypto, :wildcard_generator, :bytestream_generator

    def encrypt_key(key)
      crypto.encrypt(key)
    end

    def encrypt_value(value)
      crypto.padded_encrypt(value)
    end
  end
end
