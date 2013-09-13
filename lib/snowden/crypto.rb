require "openssl"

module Snowden
  class Crypto
    def initialize(args)
      @key = args.fetch(:key)
      @iv  = args.fetch(:iv)
    end

    def decrypt(data)
      c = symmetric_cipher
      c.decrypt
      c.key = key
      c.iv  = iv

      c.update(data) + c.final
    end

    def encrypt(data)
      c = symmetric_cipher
      c.encrypt
      c.key = key
      c.iv  = iv

      c.update(data) + c.final
    end

    private

    attr_reader :key, :iv

    def symmetric_cipher
      OpenSSL::Cipher::Cipher.new("AES-256-CBC")
    end

  end
end
