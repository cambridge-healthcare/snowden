module Snowden
  class EncryptedSearchIndex
    def initialize(args)
      @crypto             = args.fetch(:crypto)
      @backend            = args.fetch(:backend)
      @wildcard_generator = args.fetch(:wildcard_generator)
    end

    def store(key, value)
      wildcard_generator.each_wildcard(key) do |wildcard|
        backend.save(encrypt_key(wildcard), encrypt_value(value))
      end
    end

    def search(value)
      backend.find(value)
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
