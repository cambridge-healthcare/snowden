class WildcardGenerator
  def initialize(args)
    @edit_distance = args.fetch(:edit_distance)
  end

  def each_wildcard(string, &block)
    wildcards = [string]
    edit_distance.times do
      wildcards = add_wildcard_layer(wildcards)
    end

    wildcards = wildcards.uniq

    wildcards.each(&block)
  end

  private

  attr_reader :edit_distance

  def add_wildcard_layer(list_of_strings)
    list_of_strings.map {|s| base_wildcards(s) }.flatten
  end

  def base_wildcards(string)
    (string.length + 1).times.each_with_object([string]) { |i, wildcards|
      prefix = string[0...i]
      suffix = string[i...string.length]
      wildcards << "#{prefix}*#{suffix}"
      wildcards << "#{prefix[0...prefix.length-1]}*#{suffix}"
    }.uniq
  end
end
