module Snowden
  class EncryptedSearchIndex
    def initialize(args)
      @crypto             = args.fetch(:crypto)
      @backend            = args.fetch(:backend)
      @wildcard_generator = args.fetch(:wildcard_generator)
    end

    def store(key, value)
      wildcard_generator.each_wildcard(key) do |wildcard|
        backend.save(encrypt(wildcard), encrypt(OpenSSL::Random.random_bytes(PADDING_BYTE_SIZE) + value))
      end
    end

    def search(value)
      backend.find(value)
    end

    private

    attr_reader :backend, :crypto, :wildcard_generator

    def encrypt(value)
      crypto.encrypt(value)
    end
  end
end
