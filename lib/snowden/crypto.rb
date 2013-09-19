require "openssl"

module Snowden
  #@api private
  class Crypto
    def initialize(args)
      @key          = args.fetch(:key)
      @iv           = args.fetch(:iv)
      @cipher_spec  = args.fetch(:cipher_spec)
      @padding_size = args.fetch(:padding_size)
    end

    def decrypt(data)
      cipher(:decrypt, data)
    end

    def encrypt(data)
      cipher(:encrypt, data)
    end

    def padded_encrypt(data)
      encrypt(OpenSSL::Random.random_bytes(padding_size) + data)
    end

    def padded_decrypt(data)
      decrypt(data)[padding_size..-1]
    end

    private

    attr_reader :key, :iv, :cipher_spec, :padding_size

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
  end
end
