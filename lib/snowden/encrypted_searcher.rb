module Snowden
  class EncryptedSearcher
    #Creates a new search index
    #
    # @param args [Hash]
    #   A hash that must contain the following keys:
    #     * :crypto - an instance of Snowden::Crypto primed with some key and
    #                 iv. Note: the key and iv this crypto uses must match the
    #                 ones used by the index
    #     * :index - a Snowden::EncryptedSearchIndex instance .
    #     * :wildcard_generator - an instance of Snowden::WildcardGenerator
    def initialize(args)
      @crypto             = args.fetch(:crypto)
      @index              = args.fetch(:index)
      @wildcard_generator = args.fetch(:wildcard_generator)
    end

    # Looks up the search string in the index.
    #
    # @param search_string [String] the string to search the index for
    #
    # @return [ [String] ] a list of strings that were matched by the search
    #                      string in the index.
    def search(search_string)
      wildcard_generator.wildcards(search_string).flat_map { |wildcard|
        encrypted_values = encrypted_values_for_key(wildcard)
        encrypted_values.map {|v| crypto.padded_decrypt(v) }
      }.uniq
    end

    private

    attr_reader :wildcard_generator, :crypto, :index, :padding_size

    def encrypted_values_for_key(key)
      encrypted_key = crypto.encrypt(key)
      index.search(encrypted_key)
    end
  end
end
