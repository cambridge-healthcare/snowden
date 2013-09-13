require "spec_helper"
require "snowden"

module Snowden
  describe WildcardGenerator do
    let(:wildcard_generator) { WildcardGenerator.new(:edit_distance => 2) }

    let(:wildcards_fixture) { [
      "a", "*a", "a*", "*", "**a", "*a*", "**", "a**"
    ] }

    describe "#each_wildcard" do
      it "yields to the passed block" do
        called = false
        wildcard_generator.each_wildcard("a") do
          called = true
        end

        expect(called).to be true
      end

      it "gives back some wildcards" do
        expect(wildcard_generator.each_wildcard("a").to_a).to eq(wildcards_fixture)
      end
    end
  end
end
