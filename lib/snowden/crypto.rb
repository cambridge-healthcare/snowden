require "openssl"

module Snowden
  class Crypto
    def initialize(args)
      @key         = args.fetch(:key)
      @iv          = args.fetch(:iv)
      @cipher_spec = args.fetch(:cipher_spec, default_cipher_spec)
    end

    def decrypt(data)
      cipher(:decrypt, data)
    end

    def encrypt(data)
      cipher(:encrypt, data)
    end

    def padded_encrypt(data)
      encrypt(OpenSSL::Random.random_bytes(PADDING_BYTE_SIZE) + data)
    end

    def padded_decrypt(data)
      decrypt(data)[PADDING_BYTE_SIZE..-1]
    end

    private

    attr_reader :key, :iv, :cipher_spec

    def cipher(mode, data)
      c = symmetric_cipher
      c.public_send(mode)
      c.key = key
      c.iv  = iv

      c.update(data) + c.final
    end

    def symmetric_cipher
      OpenSSL::Cipher::Cipher.new(cipher_spec)
    end

    def default_cipher_spec
      "AES-256-CBC"
    end
  end
end
