require "openssl"

module Snowden
  class Crypto
    def initialize(args)
      @key = args.fetch(:key)
      @iv  = args.fetch(:iv)
    end

    def decrypt(data)
      cipher(:decrypt, data)
    end

    def encrypt(data)
      cipher(:encrypt, data)
    end

    private

    attr_reader :key, :iv

    def cipher(mode, data)
      c = symmetric_cipher
      c.public_send(mode)
      c.key = key
      c.iv  = iv

      c.update(data) + c.final
    end

    def symmetric_cipher
      OpenSSL::Cipher::Cipher.new("AES-256-CBC")
    end

  end
end
