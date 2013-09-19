module Snowden
  class WildcardGenerator
    def initialize(args)
      @edit_distance = args.fetch(:edit_distance)
    end

    # @api private
    def wildcards(string)
      wildcards = [string]
      edit_distance.times do
        wildcards = add_wildcard_layer(wildcards)
      end

      wildcards = wildcards.uniq

      wildcards.to_enum
    end

    private

    attr_reader :edit_distance

    def add_wildcard_layer(list_of_strings)
      list_of_strings.map {|s| base_wildcards(s) }.flatten
    end

    def base_wildcards(string)
      string_range = (0..string.length)

      [string]
        .concat(string_range.map { |i| string.dup.insert(i, wildcard_char) })
        .concat(string_range.map { |i| string.dup.tap { |s| s[i] = wildcard_char } })
    end

    def wildcard_char
      "*"
    end
  end
end
