require "spec_helper"
require "snowden"

module Snowden::Backends
  describe HashBackend do
    subject(:backend) { HashBackend.new(hash) }

    describe "#save" do
      let(:hash) { {} }

      it "saves the key and value in the hash" do
        backend.save(:key, :value)
        expect(hash[:key]).to eq([:value])
      end
    end

    describe "#find" do
      let(:hash) { {:key2 => :value2} }

      it "finds the value stored under the key in the hash" do
        expect(backend.find(:key2)).to eq(:value2)
      end
    end
  end
end

