module Snowden
  #The object that holds all the configuration details for Snowden
  #@attr edit_distance [Integer] the size of the edit distance sets that
  #                              are created when searching and
  #                              storing strings.
  #                              See an example at:
  #                              https://gist.github.com/samphippen/6621771.
  #                              Defaults to 3.
  #
  #@attr cipher_spec [String] an OpenSSL cipher spec to use with Snowden.
  #                           Defaults to "AES-256-CBC".
  #
  #@attr padding_byte_size [Integer] the amount of random padding to add to
  #                                  values stored in the index. Defaults to 32.
  #                                  Change at your own risk.
  #                                  Never set to lower than 2 blocks if you're
  #                                  using a block cipher.
  #
  #@attr backend The default snowden storage backend.
  #              Defaults to an instance of Snowden::Backends::HashBackend
  class Configuration
    attr_accessor :edit_distance, :cipher_spec, :padding_byte_size, :backend



    #Sets up the configuration object
    def initialize
      @edit_distance     = 3
      @cipher_spec       = "AES-256-CBC"
      @padding_byte_size = 32
      @backend           = Snowden::Backends::HashBackend.new
    end
  end
end
