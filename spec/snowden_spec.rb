require "spec_helper"
require "snowden"

describe Snowden do
  let(:key)     { "a"*(256/8) }
  let(:iv)      { "b"*(128/8) }

  describe ".new_encrypted_index" do
    subject(:index) { Snowden.new_encrypted_index(
        key,
        iv,
        Snowden::Backends::HashBackend.new({})
      )
    }

    it "gives back an index" do
      expect(index).to be_a_kind_of Snowden::EncryptedSearchIndex
    end

    it "builds an index that does crypto" do
      subject.store("encrypt me", "please")

      encrypted_value = index.search(encrypt_helper("encrypt me")).first
      decrypted_value = padded_decrypt_helper(encrypted_value)

      expect(decrypted_value).to eq("please")
    end
  end

  describe ".new_encrypted_searcher" do
    let(:index) { Snowden.new_encrypted_index(
        key,
        iv,
        Snowden::Backends::HashBackend.new({})
      )
    }
    subject(:searcher) { Snowden.new_encrypted_searcher(key, iv, index) }

    it "gives back a searcher" do
      expect(subject).to be_a_kind_of Snowden::EncryptedSearcher
    end

    it "builds a searcher that can find values in the index" do
      index.store("sam", "12345")
      index.store("gerhard", "pony")

      expect(searcher.search("gerha")).to eq(["pony"])
    end
  end

  def encrypt_helper(value)
    Snowden.crypto_for(key, iv).encrypt(value)
  end

  def padded_decrypt_helper(value)
    Snowden.crypto_for(key, iv).padded_decrypt(value)
  end
end
