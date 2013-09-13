require "spec_helper"
require "snowden"

describe Snowden do
  let(:key) { "a"*(256/8) }
  let(:iv)  { "b"*(128/8) }
  let(:backend) { Snowden::Backends::HashBackend.new }

  describe ".new_encrypted_index" do

    subject(:index) { Snowden.new_encrypted_index(key, iv, backend) }

    it "gives back an index" do
      expect(index).to be_a_kind_of Snowden::EncryptedSearchIndex
    end

    it "does the crypto correctly" do
      subject.store("encrypt me", "please")
      expect(index.search(encrypt_helper("encrypt me"))).to eq([encrypt_helper("please")])
    end

  end

  describe ".new_encrypted_searcher" do
    let(:index) { Snowden.new_encrypted_index(key, iv, backend) }
    subject(:searcher) { Snowden.new_encrypted_searcher(key, iv, index) }

    it "gives back a searcher" do
      expect(subject).to be_a_kind_of Snowden::EncryptedSearcher
    end

    it "finds values in a real index" do
      index.store("sam", "12345")
      index.store("gerhard", "pony")

      expect(searcher.search("gerha")).to eq(["pony"])
    end
  end
  def encrypt_helper(value)
    Snowden::Crypto.new(:key => key, :iv => iv).encrypt(value)
  end
end
