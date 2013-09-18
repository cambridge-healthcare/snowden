module Snowden
  class EncryptedSearcher
    def initialize(args)
      @crypto             = args.fetch(:crypto)
      @index              = args.fetch(:index)
      @wildcard_generator = args.fetch(:wildcard_generator)
    end

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
