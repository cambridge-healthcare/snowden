require "spec_helper"
require "snowden"

module Snowden
  describe EncryptedSearchIndex do
    subject(:index) {
      EncryptedSearchIndex.new(
        :crypto             => crypto,
        :backend            => backend,
        :wildcard_generator => wildcard_generator,
      )
    }

    let(:crypto)                 { double("crypto") }
    let(:key)                    { double("key")   }
    let(:value)                  { "qowijfeqwfe" }
    let(:wildcard_key)           { double("wildcard key") }
    let(:encrypted_wildcard_key) { double("encrypted wildcard key") }
    let(:encrypted_value)        { double("encrypted value") }

    let(:backend) { double("backend") }

    let(:wildcard_generator) { double("wildcard_generator") }


    describe "#save" do
      it "stores the wildcard and the encrypted value" do
        allow(wildcard_generator).to receive(:each_wildcard).with(key).and_yield(wildcard_key)
        allow(crypto).to receive(:encrypt).with(wildcard_key).and_return(encrypted_wildcard_key)
        allow(crypto).to receive(:encrypt).with(/#{value}/).and_return(encrypted_value)

        expect(backend).to receive(:save).with(encrypted_wildcard_key, encrypted_value)
        index.store(key, value)
      end
    end

    describe "#search" do
      it "retreives the value matching the passed encrypted value" do
        allow(backend).to receive(:find).with(encrypted_wildcard_key).and_return(encrypted_value)
        expect(index.search(encrypted_wildcard_key)).to be == encrypted_value
      end
    end
  end
end
