require "spec_helper"
require "snowden"

module Snowden
  describe WildcardGenerator do
    let(:wildcard_generator) { WildcardGenerator.new(:edit_distance => 2) }

    let(:wildcards_fixture) { [
      "**abc", "*abc", "*a*bc", "**bc", "*ab*c", "*a*c", "*abc*", "*ab*",
      "a**bc", "a*bc", "a*b*c", "a**c", "a*bc*", "a*b*", "*bc", "*b*c",
      "**c", "*bc*", "*b*", "ab**c", "ab*c", "ab*c*", "ab**", "a*c",
      "a*c*", "a**", "abc**", "abc*", "ab*",
      "abc"
    ] }

    describe "#each_wildcard" do
      it "yields to the passed block" do
        called = false
        wildcard_generator.each_wildcard("abc") do
          called = true
        end

        expect(called).to be true
      end

      it "gives back some wildcards" do
        expect(wildcard_generator.each_wildcard("abc").to_a).to eq(wildcards_fixture)
      end
    end
  end
end
