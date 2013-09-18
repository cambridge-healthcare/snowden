require "spec_helper"
require "snowden"

describe Snowden do
  let(:key)     { "a"*(256/8) }
  let(:iv)      { "b"*(128/8) }

  describe ".new_encrypted_index" do

    subject(:index) { Snowden.new_encrypted_index(key, iv) }

    it "gives back an index" do
      expect(index).to be_a_kind_of Snowden::EncryptedSearchIndex
    end

    it "does the crypto correctly" do
      subject.store("encrypt me", "please")
      encrypted_value = index.search(encrypt_helper("encrypt me")).first
      expect(decrypt_helper(encrypted_value)[Snowden::PADDING_BYTE_SIZE..-1]).to eq("please")
    end
  end

  describe ".new_encrypted_searcher" do
    let(:index)        { Snowden.new_encrypted_index(key, iv) }
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

  def decrypt_helper(value)
    Snowden::Crypto.new(:key => key, :iv => iv).decrypt(value)
  end
end
