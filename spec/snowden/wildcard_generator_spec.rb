require "spec_helper"
require "snowden"

module Snowden
  describe WildcardGenerator do
    let(:wildcard_generator) { WildcardGenerator.new(:edit_distance => 2) }

    let(:wildcards_fixture) { [
      "a", "*a", "a*", "*", "**a", "*a*", "**", "a**"
    ].sort }

    describe "#each_wildcard" do
      it "yields to the passed block" do
        called = false
        wildcard_generator.wildcards("a").each do
          called = true
        end

        expect(called).to be true
      end

      it "gives back some wildcards" do
        expect(wildcard_generator.wildcards("a").to_a.sort).to eq(wildcards_fixture)
      end
    end
  end
end
