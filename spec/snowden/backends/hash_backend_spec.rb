require "spec_helper"
require "snowden"

module Snowden::Backends
  describe HashBackend do
    subject(:backend) { HashBackend.new("nomspace", hash) }
    let(:hash) { {} }

    describe "#save" do
      it "returns nil" do
        expect(backend.save(:key, :value)).to be nil
      end
    end

    describe "#find" do
      let(:hash) { {["nomspace", :key2] => :value2} }

      it "finds the value stored under the key in the hash" do
        expect(backend.find(:key2)).to eq(:value2)
      end
    end

    describe "saving and finding" do
      let(:hash) { {} }

      it "can find values it has saved" do
        backend.save(:key, :value)
        expect(backend.find(:key)).to eq([:value])
      end
    end
  end
end

