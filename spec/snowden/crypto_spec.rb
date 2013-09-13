require "spec_helper"
require "snowden"

module Snowden
  describe Crypto do
    subject(:crypto) {
      Crypto.new(
        :key => key,
        :iv  => iv,
      )
    }

    let(:key) { "a"*(256/8) }
    let(:iv)  { "b"*(128/8) }

    it "can encrypt data" do
      expect(crypto.encrypt("asdf")).not_to be == "asdf"
    end

    it "can decrypt data that it encrypts" do
      expect(crypto.decrypt(crypto.encrypt("asdf"))).to be == "asdf"
    end
  end
end
