module Snowden
  class EncryptedSearcher
    def initialize(args)
      @crypto             = args.fetch(:crypto)
      @index              = args.fetch(:index)
      @wildcard_generator = args.fetch(:wildcard_generator)
    end

    def search(search_string)
      build = []

      wildcard_generator.each_wildcard(search_string) do |wildcard|
        encrypted_values = encrypt_and_search(wildcard)
        build += encrypted_values.map {|v| crypto.decrypt(v)[32..-1] }
      end

      build.uniq
    end

    private

    attr_reader :wildcard_generator, :crypto, :index

    def encrypt_and_search(string)
      encrypted_key    = crypto.encrypt(string)
      encrypted_values = index.search(encrypted_key)
    end
  end
end
