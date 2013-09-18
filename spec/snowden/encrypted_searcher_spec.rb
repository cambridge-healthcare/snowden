require "spec_helper"
require "snowden"

module Snowden
  describe EncryptedSearcher do
    subject(:searcher) {
      EncryptedSearcher.new(
        :crypto             => crypto,
        :index              => index,
        :wildcard_generator => wildcard_generator,
      )
    }

    let(:crypto)             { double("crypto") }
    let(:index)              { double("index")  }
    let(:wildcard_generator) { double("wildcard generator") }

    describe "#search" do
      let(:search_string)                    { double(:search_string) }
      let(:wildcard_search_string)           { double(:wildcard_search_string) }
      let(:encrypted_wildcard_search_string) { double(:encrypted_wildcard_search_string) }
      let(:encrypted_value)                  { double(:encrypted_value) }
      let(:decrypted_value)                  { double(:decrypted_value) }

      it "returns the decrypted first matching encrypted value" do
        allow(wildcard_generator).to receive(:wildcards)
          .and_return([wildcard_search_string].to_enum)

        allow(crypto).to receive(:encrypt)
          .with(wildcard_search_string).and_return(encrypted_wildcard_search_string)

        allow(crypto).to receive(:padded_decrypt)
          .with(encrypted_value).and_return(decrypted_value)

        allow(index).to receive(:search)
          .with(encrypted_wildcard_search_string).and_return([encrypted_value])

        expect(searcher.search(search_string)).to eq([decrypted_value])
      end

      context "with two matching encrypted values" do
        let(:encrypted_value1) { double(:encrypted_value1) }
        let(:decrypted_value1) { double(:decrypted_value1) }
        let(:encrypted_value2) { double(:encrypted_value2) }
        let(:decrypted_value2) { double(:decrypted_value2) }

        it "returns both decrypted values" do
          allow(wildcard_generator).to receive(:wildcards)
            .and_return([wildcard_search_string].to_enum)

          allow(crypto).to receive(:encrypt)
            .with(wildcard_search_string).and_return(encrypted_wildcard_search_string)

          allow(crypto).to receive(:padded_decrypt)
            .with(encrypted_value1).and_return(decrypted_value1)

          allow(index).to receive(:search)
            .with(encrypted_wildcard_search_string).and_return([encrypted_value1, encrypted_value2])

          allow(crypto).to receive(:padded_decrypt)
            .with(encrypted_value2).and_return(decrypted_value2)

          expect(searcher.search(search_string)).to eq([decrypted_value1, decrypted_value2])
        end

        context "when the values are the same" do
          let(:encrypted_value1) { double(:encrypted_value1) }
          let(:decrypted_value1) { double(:decrypted_value1) }

          it "returns both decrypted values" do
            allow(wildcard_generator).to receive(:wildcards)
              .and_return([wildcard_search_string].to_enum)

            allow(crypto).to receive(:encrypt)
              .with(wildcard_search_string).and_return(encrypted_wildcard_search_string)

            allow(index).to receive(:search)
              .with(encrypted_wildcard_search_string).and_return([encrypted_value1, encrypted_value1])

            allow(crypto).to receive(:padded_decrypt)
              .with(encrypted_value1).and_return(decrypted_value1).exactly(2).times

            expect(searcher.search(search_string)).to eq([decrypted_value1])
          end
        end
      end
    end
  end
end
