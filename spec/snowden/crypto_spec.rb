require "spec_helper"
require "snowden"

module Snowden
  describe Crypto do
    subject(:crypto) {
      Crypto.new(
        :key          => key,
        :iv           => iv,
        :cipher_spec  => cipher_spec,
        :padding_size => padding_size,
      )
    }

    let(:key) { "a"*(256/8) }
    let(:iv)  { "b"*(128/8) }

    let(:cipher_spec)  { "AES-256-CBC" }
    let(:padding_size) { double(:padding_size) }

    it "can encrypt data" do
      expect(crypto.encrypt("asdf")).not_to be == "asdf"
    end

    it "can decrypt data that it encrypts" do
      expect(crypto.decrypt(crypto.encrypt("asdf"))).to be == "asdf"
    end
  end
end
