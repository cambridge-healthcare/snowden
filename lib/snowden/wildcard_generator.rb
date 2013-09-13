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
    list_of_strings.map {|s| edit_distance_1_wildcards(s) }.flatten
  end

  def edit_distance_1_wildcards(string)
    wildcards = []
    (string.length + 1).times do |i|
      prefix = string[0...i]
      suffix = string[i...string.length]
      wildcards << prefix + "*" + suffix
      wildcards << prefix[0...prefix.length-1] + "*" + suffix
    end

    wildcards << string

    wildcards.uniq
  end
end
