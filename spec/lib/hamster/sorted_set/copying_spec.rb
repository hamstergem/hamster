require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  [:dup, :clone].each do |method|
    [
      [],
      ["A"],
      %w[A B C],
      (1..32),
    ].each do |values|
      describe "on #{values.inspect}" do
        let(:sorted_set) { SS[*values] }

        it "returns self" do
          expect(sorted_set.send(method)).to equal(sorted_set)
        end
      end
    end
  end
end