require "spec_helper"
require "hamster/sorted_set"
require "hamster/set"

describe Hamster::SortedSet do
  describe "#to_set" do
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|

      describe "on #{values.inspect}" do
        before do
          original = Hamster.sorted_set(*values)
          @result = original.to_set
        end

        it "returns a set with the same values" do
          @result.should eql(Hamster.set(*values))
        end
      end
    end
  end
end