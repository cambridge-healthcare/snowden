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
        encrypted_key = crypto.encrypt(wildcard)
        encrypted_values = index.search(encrypted_key)
        build += encrypted_values.map {|v| crypto.decrypt(v) }
      end

      build.uniq
    end

    private

    attr_reader :wildcard_generator, :crypto, :index
  end
end
